---
title: "Configuration"
version: 0.23
weight: 14
---

# Sensu Configuration

## Reference documentation

- [How does Sensu load configuration?](#how-does-sensu-load-configuration)
  - [Sensu configuration sources](#sensu-configuration-sources)
  - [Configuration load order](#configuration-load-order)
  - [Configuration merging](#configuration-merging)
  - [Configuration logging](#configuration-logging)
  - [Configuration scopes](#configuration-scopes)
    - [Configuration scopes are relative](#configuration-scopes-are-relative)
    - [Configuration scope examples](#configuration-scope-examples)
- [Sensu service init configuration](#sensu-service-init-configuration)
  - [Sensu service init configuration variables](#sensu-service-init-configuration-variables)
- [Sensu command line interfaces and arguments](#sensu-command-line-interfaces-and-arguments)
- [Sensu environment variables](#sensu-environment-variables)
- [Sensu configuration specification](#sensu-configuration-specification)
  - [Example sensu configuration](#example-sensu-configuration)
  - [Top-level configuration scopes](#top-level-configuration-scopes)

## How does Sensu load configuration?

### Sensu configuration sources

By default, the main configuration file for the Sensu platform is located at
`/etc/sensu/config.json`. However, Sensu also provides support for loading
configuration from a directory (containing multiple/disparate configuration
files), and/or environment variables. Sensu merges configuration parameters
provided from these three distinct configuration sources (environment variables,
configuration file, and configuration directories) into a single Hash. This type
of Hash merging is often called "deep merging", and is probably the most
important concept to understand when learning how to configure Sensu.

### Configuration load order

As previously mentioned, Sensu configuration can be provided via three distinct
sources: environment variables, a configuration file, and one or more
directories containing configuration files. Sensu loads configuration from these
sources in the following order:

1. The Sensu init scripts provide [command line arguments][1] for starting the
   Sensu services (e.g. the location of the configuration file (`-c`), the
   location of configuration directories (`-d`), etc).  

2. Sensu will load configuration from [environment variables][2].

3. Sensu loads configuration from the configuration file (by default, this is
   located at `/etc/sensu/config.json`).

3. Sensu loads configuration snippets from configuration files located in a
   Sensu configuration directory (by default, this is `/etc/sensu/conf.d/`,
   however it is possible to configure Sensu to load from multiple configuration
   directories; see: [command line arguments][1], below).

   _NOTE: configuration file load order is dictated by a `*.json` glob of the
   configuration directory; as such it is **strongly** recommended to avoid a
   dependency on configuration directory file load order (e.g. if you're
   attempting to name configuration files in the configuration directory to
   control load order, you're doing it wrong)._

### Configuration merging

To explain how Sensu merges configuration parameters from the various disparate
configuration sources, please note the following example scenario:

1. The Sensu runtime configuration is stored as an in-memory Hash object. For
   the purposes of providing a visual example, let's imagine that this Hash
   object is actually a JSON document, which begins life (as Sensu is started)
   as an empty JSON document.

   #### Initial Sensu configuration Hash (in memory)

   ~~~json
   {}
   ~~~

   When Sensu is started, it will begin to collect configuration from
   environment variables, a configuration file, and one ore more configuration
   directories, which configuration parameters will be used to build up this
   configuration Hash.

2. For the purposes of this example, let's assume that the first configuration
   snippet that Sensu encounters is a configuration file, located at
   `/etc/sensu/config.json` with the following contents:

   ###### New config file (on disk at `/etc/sensu/config.json`)

   ~~~json
   {
     "rabbitmq": {
       "host": "10.0.1.10",
       "vhost": "/sensu",
       "user": "sensu",
       "password": "secret"
     },
     "redis": {
       "host": "10.0.1.20",
       "port": 6379,
       "password": "secret"
     }
   }
   ~~~

   At this time, the Sensu configuration Hash (in memory) will look like:

   ###### Updated Sensu configuration Hash (in memory)

   ~~~json
   {
     "rabbitmq": {
       "host": "localhost",
       "vhost": "/sensu",
       "user": "sensu",
       "password": "secret"
     },
     "redis": {
       "host": "localhost",
       "port": 6379,
       "password": "secret"
     }
   }
   ~~~

3. Now let's see what happens when Sensu encounters another configuration
   snippet (e.g. a file located in a Sensu configuration directory, such as
   `/etc/sensu/conf.d/rabbitmq.json`):

   ###### New config file contents (on disk at `/etc/sensu/conf.d/rabbitmq.json`)

   ~~~json
   {
     "rabbitmq": {
       "host": "10.0.1.10",
       "user": "sensu01",
       "password": "newsecret"
     }
   }
   ~~~

   The second configuration snippet provided configuration for the `rabbitmq`
   scope, some of which already exists in the Sensu configuration Hash (in
   memory) - but also missing some attributes which already exist in the Sensu
   configuration Hash (i.e. `vhost`). The result of merging this configuration
   snippet into the Sensu configuration Hash (in memory) is as follows:

   ###### Updated Sensu configuration Hash (in memory)

   ~~~json
   {
     "rabbitmq": {
       "host": "10.0.1.10",
       "vhost": "/sensu",
       "user": "sensu01",
       "password": "newsecret"
     },
     "redis": {
       "host": "localhost",
       "port": 6379,
       "password": "secret"
     }
   }
   ~~~

   The result of the deep merge is that the configuration snippet provided by
   `/etc/sensu/conf.d/rabbitmq.json` was overlaid on the Sensu configuration
   Hash (in memory), essentially overwriting the previously existing values
   provided by the configuration snippet, while not discarding configuration
   attributes that already existed in the `rabbitmq` configuration scope - even
   though they weren't provided by the configuration snippet.

### Configuration logging

As configuration snippets are applied to the Sensu configuration Hash (i.e.
during "deep merge"), all configuration changes are logged to the corresponding
log file (e.g. the Sensu server, API, or Client logs).

### Configuration scopes

Because Sensu configuration can be provided in so many different sources, it is
important to understand that &ndash; _regardless of the physical location of the
configuration data (e.g. from the main configuration file, or from a
configuration file in a configuration directory)_ &ndash; all configuration
must be placed in the appropriate "scope" in the JSON file (i.e. the named
"level" that attributes should be defined in).

For example, the "root" or scope of the Sensu configuration would be any
attributes defined at the top "level" of a JSON configuration file, such as the
configuration attributes for `rabbitmq`, `redis`, or the `api`:

~~~json
{
  "rabbitmq": {},
  "redis": {},
  "api": {}
}
~~~

Attributes defined in the root scope (or top "level") provide the corresponding
scope(s) for additional configuration settings (e.g. the `rabbitmq` attribute
defined above provides the `rabbitmq` scope, a JSON Hash, for the actual RabbitMQ
configuration settings).

#### Configuration scopes are relative

Throughout the Sensu documentation whenever a configuration scope is mentioned,
it is describing the named "level" that the corresponding configuration
attributes should be defined within, **which may be _relative_ to any
potentially related scopes**. Please note the following examples:

#### Configuration scope examples

##### The client scope (`"client": {}`)

In the [Sensu Client reference documentation][3] it explains that:

> _"The client definition uses the `"client": {}` definition scope."_

Which means that, regardless where you might store a configuration file
containing Sensu client configuration on disk (assuming it is in a location that
will be loaded by Sensu), the file should contain a top "level" attribute
called `"client"`:

~~~json
{
  "client": {}  
}
~~~

##### The client socket scope (`"socket": {}`)

The [Sensu Client reference documentation][3] continues to explain that Sensu
clients may have a `"socket"` attribute, and that there are additional [Client
Socket attributes][4] which should be defined within the `"socket"` scope:

> _"The following attributes are configured within the `"socket": {}` client
definition attribute scope."_

Which means that, regardless where you might store a configuration file
containing Sensu Client Socket configuration on disk (assuming it is in a
location that will be loaded by Sensu), the file should contain a top "level"
attribute called `"client"`, _and another attribute_ defined within the
`"client"` scope (or level) called `"socket"`:

~~~json
{
  "client": {
    "socket": {}
  }
}
~~~

Thus, when the Client Socket reference documentation continues to explain that
the `bind` and `port` attributes should be defined in the Client Socket scope,
it means they should live under the `"socket"` "level" of the JSON file,
regardless of where you might store a configuration file containing said
configuration attributes on disk (assuming it is in a location that will be
loaded by Sensu).

~~~json
{
  "client": {
    "socket": {
      "bind": "0.0.0.0",
      "port": 3031
    }
  }
}
~~~

## Sensu service init configuration

The Sensu services are managed by init scripts that are provided in the Sensu
packages. The Sensu init scripts are able to start/stop/restart the
corresponding Sensu services (e.g. the Sensu server, API, client, etc).

The default Sensu init scripts and related configuration file(s) (containing
configuration variables) are located as follows:

- `/etc/default/sensu` (sourced by the init scripts to provide [configuration
  variables][5])
- `/etc/init.d/sensu-service` (shared init script used by the Sensu service
  init scripts)
- `/etc/init.d/sensu-server`
- `/etc/init.d/sensu-api`
- `/etc/init.d/sensu-client`
- `/etc/init.d/sensu-enterprise`
- `/etc/init.d/sensu-enterprise-dashboard`

### Sensu service init configuration variables

The following configuration variables can be set in the init script(s) for the
platform.

`EMBEDDED_RUBY`
: description
  : If the Sensu embedded Ruby runtime is used for check executions, adding Ruby
    to Sensu's `$PATH`.
: required
  : false
: default
  : `true` (for versions >0.21)
: example
  : ~~~ shell
    EMBEDDED_RUBY=true
    ~~~

`CONFIG_FILE`
: description
  : The primary configuration file path.
: required
  : false
: default
  : `/etc/sensu/config.json`
: example
  : ~~~ shell
    CONFIG_FILE=/etc/sensu/config.json
    ~~~

`CONFIG_DIR`
: description
  : The configuration snippet directory path.
: required
  : false
: default
  : `/etc/sensu/conf.d`
: example
  : ~~~ shell
    CONFIG_DIR=/etc/sensu/conf.d
    ~~~

`EXTENSION_DIR`
: description
  : The Sensu extension directory path.
: required
  : false
: default
  : `/etc/sensu/extensions`
: example
  : ~~~ shell
    EXTENSION_DIR=/etc/sensu/extensions
    ~~~

`PLUGINS_DIR`
: description
  : The Sensu plugins directory path, to add to the Sensu's `$PATH`.
: required
  : false
: default
  : `/etc/sensu/plugins`
: example
  : ~~~ shell
    PLUGINS_DIR=/etc/sensu/plugins
    ~~~

`HANDLERS_DIR`
: description
  : The Sensu handlers directory path, to add to Sensu's `$PATH`. This is only
    used by the Sensu server.
: required
  : false
: default
  : `/etc/sensu/handlers`
: example
  : ~~~ shell
    HANDLERS_DIR=/etc/sensu/handlers
    ~~~

`LOG_DIR`
: description
  : The log file directory path.
: required
  : false
: default
  : `/var/log/sensu`
: example
  : ~~~ shell
    LOG_DIR=/var/log/sensu
    ~~~

`LOG_LEVEL`
: description
  : The log level to default the logger to.
: required
  : false
: default
  : `info`
: allowed values
  : `debug`, `info`, `warn`, `error`, `fatal`
: example
  : ~~~ shell
    LOG_LEVEL=info
    ~~~

`PID_DIR`
: description
  : The PID directory path.
: required
  : false
: default
  : `/var/run/sensu`
: example
  : ~~~ shell
    PID_DIR=/var/run/sensu
    ~~~

`USER`
: description
  : The Sensu user to run the process as.
: required
  : false
: default
  : `sensu`
: example
  : ~~~ shell
    USER=sensu
    ~~~

`SERVICE_MAX_WAIT`
: description
  : The max wait time for process start/stop.
: required
  : false
: default
  : `10`
: example
  : ~~~ shell
    SERVICE_MAX_WAIT=10
    ~~~

## Sensu command line interfaces and arguments

The Sensu services can be run from the command line with the following command
line options:

_NOTE: these options will work with ALL of the Sensu services (`sensu-server`,
`sensu-api`, `sensu-client`, and  `sensu-enterprise`)._

`-h` (`--help`)
: description
  : Display the help documentation.
: examples
  : ~~~ shell
    $ /opt/sensu/bin/sensu-server -h
    Usage: sensu-server [options]
        -h, --help                       Display this message
        -V, --version                    Display version
        -c, --config FILE                Sensu JSON config FILE
        -d, --config_dir DIR[,DIR]       DIR or comma-delimited DIR list for Sensu JSON config files
        -P, --print_config               Print the compiled configuration and exit
        -e, --extension_dir DIR          DIR for Sensu extensions
        -l, --log FILE                   Log to a given FILE. Default: STDOUT
        -L, --log_level LEVEL            Log severity LEVEL
        -v, --verbose                    Enable verbose logging
        -b, --background                 Fork into the background
        -p, --pid_file FILE              Write the PID to a given FILE

    $ /opt/sensu/bin/sensu-install -h
    Usage: sensu-install [options]
    -h, --help                       Display this message
    -v, --verbose                    Enable verbose logging
    -p, --plugin PLUGIN              Install a Sensu PLUGIN
    -P, --plugins PLUGIN[,PLUGIN]    PLUGIN or comma-delimited list of Sensu plugins to install
    -s, --source SOURCE              Install Sensu plugins from a custom SOURCE
    ~~~

`-V` (`--version`)
: description
  : Display the Sensu version.
: example
  : ~~~ shell
    $ /opt/sensu/bin/sensu-client -V
    0.23.0
    ~~~

`-c` (`--config FILE`)
: description
  : Provide the path to the Sensu configuration `FILE`.
: example
  : ~~~ shell
    /opt/sensu/bin/sensu-api -c /etc/sensu/config.json
    ~~~

`-d` (`--config_dir DIR[,DIR]`)
: description
  : Provide the path to the Sensu configuration `DIR`, or comma delimited `DIR`
    list. Configuration directories are loaded in the order provided.
: example
  : ~~~ shell
    /opt/sensu/bin/sensu-server -d /etc/sensu/conf.d,/path/to/more/configuration
    ~~~

`-P` (`--print_config`)
: description
  : Load and print Sensu configuration to STDOUT.
: dependencies
  : Requires `-c` (`--config`) and `-d` (`--config_dir`) CLI arguments to be
    provided so the Sensu service knows where to load configuration from.
: example
  : ~~~ shell
    $ sudo -u sensu /opt/sensu/bin/sensu-client -P -c /etc/sensu/config.json -d /etc/sensu/conf.d/
    {"timestamp":"2016-04-08T16:41:35.699200-0700","level":"warn","message":"loading config file","file":"/etc/sensu/config.json"}
    {"timestamp":"2016-04-08T16:41:35.699411-0700","level":"warn","message":"loading config files from directory","directory":"/etc/sensu/conf.d/"}
    {"timestamp":"2016-04-08T16:41:35.699456-0700","level":"warn","message":"loading config file","file":"/etc/sensu/conf.d/check-sensu-website.json"}
    {"timestamp":"2016-04-08T16:41:35.699551-0700","level":"warn","message":"config file applied changes","file":"/etc/sensu/conf.d/check-sensu-website.json","changes":{"checks":{"sensu_website":[null,{"command":"check-http.rb -u https://sensuapp.org","subscribers":["production"],"interval":60,"publish":false}]}}}
    {"timestamp":"2016-04-08T16:41:35.699597-0700","level":"warn","message":"loading config file","file":"/etc/sensu/conf.d/client.json"}
    {"timestamp":"2016-04-08T16:41:35.699673-0700","level":"warn","message":"config file applied changes","file":"/etc/sensu/conf.d/client.json","changes":{"client":[null,{"name":"client-01","address":"127.0.0.1","environment":"development","subscriptions":["production"],"socket":{"bind":"127.0.0.1","port":3030}}]}}
    {"timestamp":"2016-04-08T16:41:35.700246-0700","level":"warn","message":"outputting compiled configuration and exiting"}
    {
      "transport":{
        "name":"redis",
        "reconnect_on_error":true
      },
      "checks":{
        "sensu_website":{
          "command":"check-http.rb -u https://sensuapp.org",
          "subscribers":[
            "production"
          ],
          "interval":60,
          "publish":false
        }
      },
      "filters":{},
      "mutators":{},
      "handlers":{},
      "redis":{
        "host":"127.0.0.1"
      },
      "api":{
        "host":"127.0.0.1",
        "port":4567
      },
      "client":{
        "name":"client-01",
        "address":"127.0.0.1",
        "environment":"development",
        "subscriptions":[
          "production"
        ],
        "socket":{
          "bind":"127.0.0.1",
          "port":3030
        }
      }
    }
    ~~~

    _NOTE: this command needs to be run as the `sensu` user (or as a user with
    elevated privileges) in order for Sensu to access its configuration files)._

    _PRO TIP: to generate config output without log entries, try setting the
    `-L` (`--log_level`) CLI argument to `error` or `fatal` (e.g. `-L fatal`)._

`-e` (`--extensions_dir DIR`)
: description
  : Provide the path to the Sensu extensions `DIR`.
: example
  : ~~~ shell
    /opt/sensu/bin/sensu-server -e /etc/sensu/extensions
    ~~~

`-l` (`--log LOG`)
: description
  : The path to the `LOG` file. Defaults to `STDOUT` if not provided.
: example
  : ~~~ shell
    /opt/sensu/bin/sensu-server -l /var/log/sensu/sensu-server.log
    ~~~

`-L` (`--log_level LEVEL`)
: description
  : Log security `LEVEL`
: allowed values
  : `debug`, `info`, `warn`, `error`, `fatal`
: example
  : ~~~ shell
    /opt/sensu/bin/sensu-server -L warn
    ~~~

`-v` (`--verbose`)
: description
  : Enable verbose logging.
: example
  : ~~~ shell
    /opt/sensu/bin/sensu-client -v
    ~~~

`-b` (`--background`)
: description
  : Detach the process and run in the background (i.e. run as a "daemon")
: example
  : ~~~ shell
    /opt/sensu/bin/sensu-server -b
    ~~~

`-p` `(--pid_file FILE)`
: description
  : Write the PID to a given `FILE`.
: example
  : ~~~ shell
    /opt/sensu/bin/sensu-server -p /var/run/sensu-server.pid
    ~~~


## Sensu environment variables

The Sensu services are aware of the following environment variables.
Configuration provided via environment variables will only be used if no
corresponding configuration is provided via the Sensu configuration file, or
configuration directories. Providing configuration via environment variables is
primarily beneficial in environments where configuration management tools (e.g.
Chef or Puppet) are not used &ndash; for example, in container-based
environments.

`SENSU_CLIENT_NAME`
: description
  : The Sensu client `name`, used if a client definition does not already
    provide one.
: type
  : String
: required
  : false
: example
  : ~~~ shell
    SENSU_CLIENT_NAME="container-01"
    ~~~

`SENSU_CLIENT_ADDRESS`
: description
  : The Sensu client `address`, used if a client definition does not already
    define one.
: type
  : String
: required
  : false
: default
  : `hostname`
: example
  : ~~~ shell
    SENSU_CLIENT_ADDRESS="8.8.8.8"
    ~~~

`SENSU_CLIENT_SUBSCRIPTIONS`
: description
  : The Sensu client `subscriptions`, comma delimited, used if a client definition
    does not already define them.
: type
  : Array
: required
  : false
: default
  : `[]`
: example
  : ~~~ shell
    SENSU_CLIENT_SUBSCRIPTIONS="production,webserver,nginx,memcached,all"
    ~~~

`SENSU_TRANSPORT_NAME`
: description
  : The Sensu transport name, indicating the Sensu transport to load and use.
    This value is used if a transport definition does not already define one.
: type
  : String
: required
  : false
: default
  : `rabbitmq`
: example
  : ~~~ shell
    SENSU_TRANSPORT_NAME="redis"
    ~~~

`RABBITMQ_URL`
: description
  : The RabbitMQ URL Sensu will use when connecting to RabbitMQ, used if a
    RabbitMQ definition does not already define connection options. The RabbitMQ
    URL uses the [AMQP URI spec][6].
: type
  : String
: required
  : false
: example
  : ~~~ shell
    RABBITMQ_URL="amqp://user:password@hostname:5672/%2Fvhost"
    ~~~

`REDIS_URL`
: description
  : The Redis URL Sensu will use when connecting to Redis, used if a Redis
    definition does not already define connection options.
: type
  : String
: required
  : false
: example
  : ~~~ shell
    REDIS_URL="redis://hostname:6379/0"
    ~~~

`SENSU_API_PORT`
: description
  : The Sensu API TCP port to bind to and listen on, used if an API definition
    does not already define one. This is only used by the Sensu API.
: type
  : Integer
: required
  : false
: default
  : `4567`
: example
  : ~~~ shell
    SENSU_API_PORT=8080
    ~~~

## Sensu configuration specification

### Example Sensu configuration

The following is an example Sensu configuration, a JSON configuration file
located at `/etc/sensu/config.json`. This Sensu configuration provides Sensu
with information it needs to communicate with RabbitMQ and Redis:

~~~json
{
  "rabbitmq": {
    "host": "10.0.1.10",
    "vhost": "/sensu",
    "user": "sensu",
    "password": "secret"
  },
  "redis": {
    "host": "10.0.1.20",
    "port": 6379,
    "password": "secret"
  },
  "api": {
    "host": "10.0.1.30",
    "bind": "0.0.0.0",
    "port": "4242"
  }
}
~~~

### Top-level configuration scopes

The top-level Sensu configuration scopes are as follows (these attributes live
at the top level of their respective JSON documents):

`rabbitmq`
: description
  : The RabbitMQ definition scope (see: [RabbitMQ Configuration][7])
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    {
      "rabbitmq": {
        "host": "10.0.1.10",
        "vhost": "/sensu",
        "user": "sensu",
        "password": "secret"
      }
    }
    ~~~

`redis`
: description
  : The Redis definition scope (see: [Redis Configuration][8])
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    {
      "redis": {
        "host": "10.0.1.20",
        "port": 6379,
        "password": "secret"
      }
    }
    ~~~

`transport`
: description
  : The Sensu Transport definition scope (see: [Transport Configuration][9]).
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    {
      "transport": {
        "name": "rabbitmq"
      }
    }
    ~~~

`api`
: description
  : The Sensu API definition scope (see: [API Configuration][10])
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    {
      "api": {
        "host": "10.0.1.30",
        "bind": "0.0.0.0",
        "port": 4242
      }
    }
    ~~~

`client`
: description
  : The Sensu Client definition scope (see: [Clients][3])
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    {
      "client": {
        "name": "i-424242",
        "address": "8.8.8.8",
        "subscriptions": [
          "production",
          "webserver",
          "mysql"
        ]
      }
    }
    ~~~

`checks`
: description
  : The Sensu Checks definition scope (see: [Checks][11])
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    {
      "checks": {
        "example_check": {},
        "another_check": {}
      }
    }
    ~~~

`handlers`
: description
  : The Sensu Handlers definition scope (see: [Handlers][12])
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    {
      "handlers": {
        "example_handler": {},
        "another_handler": {}
      }
    }
    ~~~

`filters`
: description
  : The Sensu Filters definition scope (see: [Filters][13])
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    {
      "filters": {
        "example_filter": {},
        "another_filter": {}
      }
    }
    ~~~

`mutators`
: description
  : The Sensu Mutators definition scope (see: [Mutators][14])
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    {
      "mutators": {
        "example_mutator": {},
        "another_mutator": {}
      }
    }
    ~~~

[1]:  #sensu-command-line-interfaces-and-arguments
[2]:  #sensu-environment-variables
[3]:  clients.html#client-definition-specification
[4]:  clients.html#socket-attributes
[5]:  #sensu-service-init-configuration-variables
[6]:  https://www.rabbitmq.com/uri-spec.html
[7]:  rabbitmq.html#rabbitmq-definition-specification
[8]:  redis.html#redis-definition-specification
[9]:  transport.html#transport-definition-specification
[10]: api-configuration.html#api-definition-specification
[11]: checks.html#check-definition-specification
[12]: handlers.html#handler-definition-specification
[13]: filters.html#filter-definition-specification
[14]: mutators.html#mutator-definition-specification
