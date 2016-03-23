---
version: 0.22
category: "Installation Guide"
title: "Installation Prerequisites"
next:
  url: "install-redis"
  text: "Install Redis"
---

# Installation Prerequisites

As mentioned earlier in this guide, Sensu's [architecture](architecture) is one
of its most compelling features. While this modular design makes it infinitely
adaptable to monitor any infrastructure, it also depends on some external
services to function:

- [Data Store (Redis)](#data-store)
- [Transport](#transport)

_NOTE: this guide will focus on installing Sensu's dependencies in a
[standalone](installation-strategies#standalone) configuration. However, in a
live/production environment, it is strongly recommended that &ndash; at minimum
&ndash; the Sensu data store and transport run on a different system than the
Sensu server and API (i.e. in a [distributed](installation-strategies#
distributed) or [high availability](installation-strategies#high-availability)
configuration). Please review the Sensu [Installation Strategies](installation-\
strategies) for more information._

## Data Store (Redis) {#data-store}

[Redis][redis] is a key-value database, which [describes itself][redis-about] as
_"an open source, BSD licensed, advanced key-value cache and store"_. Sensu uses
Redis as a [data-store](data-store) for storing persistent data such as the
client registry and check results. Two Sensu Core services, the server and API
require access to the same instance of Redis to function (i.e. the Sensu client
does not communicate with Redis).

## Transport {#sensu-transport}

Sensu services use a message bus (e.g. [RabbitMQ][rabbitmq]) for communication.
This message bus communication is provided by the [Sensu
Transport](transport), which is a library that makes it possible to leverage
alternate transport solutions in  place of RabbitMQ (the default transport).
Sensu services requires access to the  same instance of the defined transport
(e.g. a RabbitMQ cluster) to  function. Sensu check requests and check results
are published as "messages" to  the Sensu Transport, and the corresponding Sensu
services receive these messages  by subscribing to the appropriate
subscriptions.

### Selecting a Transport

The Sensu Transport library makes it possible to replace Sensu's recommended and
default transport (RabbitMQ) with alternative solutions. There are currently
two (2) transports provided with the sensu-transport library: RabbitMQ and
Redis &mdash; each presenting unique performance and functional characteristics.

#### The RabbitMQ Transport (recommended)

The RabbitMQ Transport is the original Sensu transport, and continues to be the
recommended solution for running Sensu in production environments.

##### Pros {#rabbitmq-transport-pros}

- Native SSL support
- Pluggable authentication framework
- Support for ACLs

##### Cons {#rabbitmq-transport-cons}

- Adds Erlang as a runtime dependency to the Sensu architecture

  _NOTE: to be clear, Erlang only needs to be installed on the system(s) where
  RabbitMQ is running. For more information, please see the [FAQ][faq]._

#### The Redis Transport

The Redis Transport was an obvious alternative to the original RabbitMQ
Transport because Sensu already depends on Redis as a data store. Using Redis as
a transport greatly simplifies Sensu's architecture by removing the need to
install/configure RabbitMQ _and_ [Erlang](https://www.erlang.org/) (RabbitMQ's
runtime).

##### Pros {#redis-transport-pros}

- Simplifies Sensu architecture by removing need for dedicated transport (by
  using Redis as the data store _and_ transport)
- Comparable or better throughput/performance than RabbitMQ

##### Cons {#redis-transport-cons}

- No native support for SSL


[rabbitmq]:         rabbitmq
[redis]:            redis
[redis-about]:      http://redis.io/topics/introduction
[faq]:              https://sensuapp.org/faq
