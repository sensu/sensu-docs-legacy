---
title: "Sensu Transport"
description: "Reference documentation for the Sensu Transport."
version: 0.26
weight: 13
---

# Sensu Transport

## Reference documentation

- [What is the Sensu Transport?](#what-is-the-sensu-transport)
- [Selecting a transport](#selecting-a-transport)
- [Transport configuration](#transport-configuration)
  - [Example transport definition](#example-transport-definition)
  - [Transport definition specification](#transport-definition-specification)
    - [Transport attributes](#transport-attributes)

## What is the Sensu Transport?

Sensu services use a message bus (e.g. [RabbitMQ][1]) for communication. This
message bus communication is provided by the [Sensu Transport][2], which is  a
library that makes it possible to leverage alternate transport solutions in
place of RabbitMQ (the default transport). Sensu services requires access to the
same instance of the defined transport (e.g. a RabbitMQ server or cluster) to
function. Sensu check requests and check results are published as “messages” to
the Sensu Transport, and the corresponding Sensu services receive these messages
by subscribing to the appropriate subscriptions.

## Selecting a Transport

The Sensu Transport library makes it possible to replace Sensu's recommended and
default transport (RabbitMQ) with alternative solutions. There are currently
two (2) transports provided with the sensu-transport library: RabbitMQ and
Redis &mdash; each presenting unique performance and functional characteristics.

### The RabbitMQ Transport (recommended)

The RabbitMQ Transport is the original Sensu transport, and continues to be the
recommended solution for running Sensu in production environments.

#### Pros {#rabbitmq-transport-pros}

- Native SSL support
- Pluggable authentication framework
- Support for ACLs

#### Cons {#rabbitmq-transport-cons}

- Adds Erlang as a runtime dependency to the Sensu architecture (only on systems
  where RabbitMQ is running)

### The Redis Transport

The Redis Transport was an obvious alternative to the original RabbitMQ
Transport because Sensu already depends on Redis as a data store. Using Redis as
a transport greatly simplifies Sensu's architecture by removing the need to
install/configure RabbitMQ _and_ [Erlang](https://www.erlang.org/) (RabbitMQ's
runtime).

#### Pros {#redis-transport-pros}

- Simplifies Sensu architecture by removing need for dedicated transport (by
  using Redis as the data store _and_ transport)
- Comparable or better throughput/performance than RabbitMQ

#### Cons {#redis-transport-cons}

- No native support for SSL
- No support for transport "consumers" metrics (see [Health & Info API][4])

## Transport configuration

### Example transport definition

The following is an example transport definition, a JSON configuration file
located at `/etc/sensu/conf.d/transport.json`. This example transport
configuration indicates that Redis should be used as the Sensu transport.

~~~ json
{
  "transport": {
    "name": "redis",
    "reconnect_on_error": true
  }
}
~~~

### Transport definition specification

The Sensu Transport uses the `"transport": {}` [definition scope][3].

#### Transport attributes

The following attributes are defined within the `"transport": {}`
[definition scope](configuration#configuration-scopes).

`name`
: description
  : The Transport driver to use.
: required
  : false
: type
  : String
: allowed values
  : `rabbitmq`, `redis`
: default
  : `rabbitmq`
: example
  : ~~~ shell
    "name": "redis"
    ~~~

`reconnect_on_error`
: description
  : Attempt to reconnect after a connection error.
: required
  : false
: type
  : String
: default
  : `true`
: example
  : ~~~ shell
    "reconnect_on_error": "false"
    ~~~


[1]:  rabbitmq.html
[2]:  http://github.com/sensu/sensu-transport
[3]:  configuration.html#configuration-scopes
[4]:  ../api/health-and-info-api.html
