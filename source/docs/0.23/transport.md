---
version: 0.23
category: "Reference Docs"
title: "Sensu Transport"
next:
  url: "rabbitmq"
  text: "RabbitMQ Configuration"
---

# Sensu Transport

## Reference documentation

- [What is the Sensu Transport?](#what-is-the-sensu-transport)
- [Sensu transport options](#sensu-transport-options)
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

## Sensu Transport Options

Sensu currently supports the following Transports:

- [RabbitMQ (default)](rabbitmq)
- [Redis](redis)

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

name
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

reconnect_on_error
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


[1]:  rabbitmq
[2]:  http://github.com/sensu/sensu-transport
[3]:  configuration#configuration-scopes
