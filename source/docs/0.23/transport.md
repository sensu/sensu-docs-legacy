---
version: 0.23
category: "Reference Docs"
title: "Sensu Transport"
next:
  url: "rabbitmq"
  text: "RabbitMQ Configuration"
---

# Sensu Transport

Sensu services use a message bus (e.g. [RabbitMQ](rabbitmq)) for communication.
This message bus communication is provided by the [Sensu
Transport][transport-github], which is a library that makes it possible to
leverage alternate transport solutions in place of RabbitMQ (the default
transport). Sensu services requires access to the same instance of the defined
transport (e.g. a RabbitMQ server or cluster) to function. Sensu check requests
and check results are published as “messages” to the Sensu Transport, and the
corresponding Sensu services receive these messages by subscribing to the
appropriate subscriptions.

## Anatomy of a Sensu Transport definition

The Sensu Transport uses the `"transport": {}`
[definition scope](configuration#configuration-scopes).

### Definition attributes

transport
: description
  : The [Sensu Transport](https://github.com/sensu/sensu-transport) to use.
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

### Transport definition attributes

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

## Sensu Transport Options

Sensu currently supports the following Transports:

- [RabbitMQ (default)](rabbitmq)
- [Redis](redis)

[transport-github]:           http://github.com/sensu/sensu-transport
