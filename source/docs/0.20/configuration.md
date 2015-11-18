---
version: 0.20
category: "Reference Docs"
title: "Configuration"
next:
  url: "clients"
  text: "Clients"
---

# Overview

One of the most commonly asked questions when getting started with Sensu is
"where do the config files go"? Because Sensu was designed to be used alongside
configuration management solutions (e.g. [Chef](https://www.chef.io) and
[Puppet](https://puppetlabs.com)) and other automation tools, the answer to this
question has always been multifaceted.

This reference document provides information to help you:

- [Understand how the Sensu services are configured](#sensu-configuration-sources)
- [Understand how configuration merging works](#how-configuration-merging-works)
- [Understand configuration "scopes"](#configuration-scopes)
- [Understand the order in which Sensu loads configuration](#configuration-load-order)
- [Understand the anatomy of the Sensu configuration](#anatomy-of-a-sensu-configuration)

# Sensu configuration sources {#sensu-configuration-sources}

By default, the main configuration file for the Sensu platform is located at
`/etc/sensu/config.json`. However, Sensu also provides support for loading
configuration from a directory (containing multiple/disparate configuration
files), and/or environment variables. Sensu merges configuration parameters
provided from these three distinct configuration sources (environment variables,
configuration file, and configuration directories) into a single Hash. This type
of Hash merging is often called "deep merging", and is probably the most
important concept to understand when learning how to configure Sensu.

## How configuration merging works {#how-configuration-merging-works}

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

   #### New configuration file (on disk at `/etc/sensu/config.json`)

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

   #### Updated Sensu configuration Hash (in memory)

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

   #### New configuration file contents (on disk at `/etc/sensu/conf.d/rabbitmq.json`)

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

   #### Updated Sensu configuration Hash (in memory)

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

## Configuration scopes {#configuration-scopes}

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

### Configuration scopes are relative {#configuration-scopes-are-relative}

Throughout the Sensu documentation whenever a configuration scope is mentioned,
it is describing the named "level" that the corresponding configuration
attributes should be defined within, **which may be _relative_ to any
potentially related scopes**. Please note the following examples:

#### The client scope (`"client": {}`)

In the [Sensu Client reference documentation](clients#anatomy-of-a-client-definition)
it explains that:

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

#### The client socket scope (`"socket": {}`)

The [Sensu Client reference documentation](clients#anatomy-of-a-client-definition)
continues to explain that Sensu clients may have a `"socket"` attribute, and
that there are additional [Client Socket attributes](clients#socket-attributes)
which should be defined within the `"socket"` scope:

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

## Configuration load order {#configuration-load-order}

Sensu configuration can be provided via three distinct sources: environment
variables, a configuration file, and one or more directories containing
configuration files. Sensu loads configuration from these sources in the
following order:

1. The Sensu init script provides the locations for the configuration file
   (`-c`) and configuration directory (`-d`) when the corresponding Sensu
   service is started. For example:

   ~~~shell
   /opt/sensu/bin/sensu-server -b -c /etc/sensu/config.json -d /etc/sensu/conf.d/
   ~~~

   _NOTE: Environment variables will override the configuration file (`-c`) and
   configuration directory (`-d`) locations provided by the init script._

2. Sensu loads configuration settings from the following environment variables
   (primarily useful for configuring the Sensu Client; see [Client Configuration
   Environment Variables](clients#client-configuration-environment-variables)
   for more information):

   - `SENSU_TRANSPORT_NAME`
   - `RABBITMQ_URL`
   - `REDIS_URL`
   - `SENSU_CLIENT_NAME`
   - `SENSU_CLIENT_ADDRESS`
   - `SENSU_CLIENT_SUBSCRIPTIONS`
   - `SENSU_API_PORT`

3. Sensu loads configuration from the configuration file (by default, this is
   located at `/etc/sensu/config.json`).

4. Sensu loads configuration snippets from configuration files located in a
   Sensu configuration directory (by default, this is `/etc/sensu/conf.d/`).

   _NOTE: configuration file load order is dictated by a order provided by a
   `*.json` glob of the configuration directory; as such it is **strongly**
   recommended to avoid a dependency on configuration directory file load
   order (e.g. if you're attempting to name configuration files in the
   configuration directory to control load order, you're doing it wrong)._

5. As configuration snippets are applied to the Sensu configuration Hash (i.e.
   during "deep merge"), all configuration changes are logged to the
   corresponding log file (e.g. the Sensu server, API, or Client logs).

   _NOTE: the Sensu configuration logger will automatically redact sensitive
   information contained within keys named `password`, `passwd`, `pass`,
   `api_key`, `api_token`, `access_key`, `secret_key`, `private_key`, and
   `secret`._

# Anatomy of a Sensu configuration {#anatomy-of-a-sensu-configuration}

## Example Sensu configuration {#example-sensu-configuration}

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

## Configuration attributes {#configuration-attributes}

The Sensu configuration attributes defined at the "root" scope are as follows
(these attributes live at the top level of their respective JSON documents):

rabbitmq
: description
  : The RabbitMQ definition scope (see:
    [RabbitMQ Configuration](rabbitmq#anatomy-of-a-rabbitmq-definition))
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "rabbitmq": {
      "host": "10.0.1.10",
      "vhost": "/sensu",
      "user": "sensu",
      "password": "secret"
    }
    ~~~

redis
: description
  : The Redis definition scope (see:
    [Redis Configuration](redis#anatomy-of-a-redis-definition))
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "redis": {
      "host": "10.0.1.20",
      "port": 6379,
      "password": "secret"
    }
    ~~~

api
: description
  : The Sensu API definition scope (see:
    [API Configuration](api-configuration#anatomy-of-an-api-definition))
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "api": {
      "host": "10.0.1.30",
      "bind": "0.0.0.0",
      "port": 4242
    }
    ~~~
