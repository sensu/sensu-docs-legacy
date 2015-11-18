---
version: 0.20
category: "Reference Docs"
title: "Sensu Configuration"
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

- [Understand how Sensu is configured](#sensu-configuration-overview)
- [Understand the order in which Sensu loads configuration settings](#configuration-load-order)
- [Understand the anatomy of the Sensu configuration](#configuring-sensu)

# Sensu Configuration {#sensu-configuration-overview}

The main configuration file for Sensu is located at `/etc/sensu/config.json`,
however Sensu also provides support for loading configuration from a
configuration directory (containing multiple/disparate configuration files),
and/or environment variables. Sensu merges configuration parameters provided
from these three distinct configuration sources (environment variables,
configuration file, and one or more configuration directories) into a single
Hash. This type of Hash merging is often called "deep merging", as it is
possible

## Example Effect of Configuration Merging {#example-effect-of-configuration-merging}

To explain how Sensu merges configuration parameters from the various disparate
configuration sources, please note the following:

1. Sensu runtime configuration is a Hash object. For the purposes of this
   example, let's imagine that this Hash object is actually a JSON document,
   which begins life (before Sensu is started) as an empty JSON document.

   #### Initial Sensu configuration Hash (in memory)

   ~~~json
   {}
   ~~~

   When Sensu is started, it will begin to collect configuration from environment
   variables, a configuration file, and one ore more configuration directories.

2. For the purposes of this example, let's assume that the first configuration
   that encounters is a configuration file, located at `/etc/sensu/config.json`
   with the following contents:

   #### New configuration file (on disk at `/etc/snesu/config.json`)

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

3. Now let's see what happens when Sensu encounters another configuration file
   (e.g. a file located in a Sensu configuration directory, such as
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

   The second configuration file provided configuration for the `rabbitmq` scope,
   which already exists in the Sensu configuration Hash (in memory). The
   result of merging this configuration into the Sensu configuration Hash (in
   memory) is as follows:

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
   Hash (in memory), essentially overwriting the previous values.


## Configuration Load Order {#configuration-load-order}

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

2. ASSUMPTION: Sensu loads configuration settings from the following environment
   variables:

   - `SENSU_TRANSPORT_NAME`
   - `RABBITMQ_URL`
   - `REDIS_URL`
   - `SENSU_CLIENT_NAME`
   - `SENSU_CLIENT_ADDRESS`
   - `SENSU_CLIENT_SUBSCRIPTIONS`
   - `SENSU_API_PORT`

3. Sensu loads configuration settings from the configuration file (by default,
   this is `/etc/sensu/config.json`).

4. Sensu loads configuration snippets from configuration files located in the
   Sensu configuration directory (by default, this is `/etc/sensu/conf.d/`).

   _NOTE: configuration file load order is dicated by a order provided by a
   `*.json` glob of the configuration directory; as such it is **strongly**
   recommended to avoid a dependency on configuration directory file load
   order (e.g. if you're attempting to name configuration files in the
   configuration directory to control load order, you're doing it wrong)._

5. As config snippets are applied to the Sensu configuration Hash, (i.e. during
   "deep merge"), the changes are logged to the corresponding log file (e.g.
   the Sensu server, API, or Client logs).

   _NOTE: the Sensu configuration logger will automatically redact sensitive
   information contained within keys named `password`, `passwd`, `pass`,
   `api_key`, `api_token`, `access_key`, `secret_key`, `private_key`, and
   `secret`._

6. Config logger automatically redacts sensitive information (!); see:
   - https://github.com/sensu/sensu/blob/master/lib/sensu/utilities.rb#L56-L86
   - https://github.com/sensu/sensu/blob/master/lib/sensu/daemon.rb#L64-L74
   - https://github.com/sensu/sensu/blob/master/lib/sensu/daemon.rb#L76-L94

# Anatomy of a Sensu Configuration {#anatomy-of-a-sensu-configuration}

## Example Sensu Configuration {#example-sensu-configuration}

The following is an example Sensu check definition, a JSON configuration file
located at `/etc/sensu/config.json`. This Sensu configuration provides Sensu
with information it needs to communicate with other Sensu services.

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

The main Sensu configuration uses the "root" scope (i.e. these attributes live
at the top-level of the JSON document).

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
      "port": "4242"
    }
    ~~~
