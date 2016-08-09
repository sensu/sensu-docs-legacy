---
version: 0.21
category: "Reference Docs"
title: "Transport"
next:
  url: "rabbitmq"
  text: "RabbitMQ Configuration"
---

# Transport

Sensu services use a message bus (e.g. RabbitMQ) to communicate with one
another (technically speaking, the Sensu services don't actually communicate
_with each other_ &ndash; they only communicate with the message bus). As of
[Sensu Core version 0.13](https://github.com/sensu/sensu/blob/master/CHANGELOG.md#0130---2014-06-12)
this message bus communication in Sensu has been abstracted as the
[Sensu Transport](https://github.com/sensu/sensu-transport), making it possible
to leverage alternate transport solutions in place of RabbitMQ (the default
Transport). Sensu services requires access to the same instance of the defined
Sensu Transport (e.g. a RabbitMQ cluster) to function. Sensu check requests and
check results are published as "messages" to the Sensu Transport, and the
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

- [RabbitMQ (default)](redis)
- [Redis](redis)
