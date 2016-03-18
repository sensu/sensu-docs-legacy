---
version: 0.22
category: "Installation Guide"
title: "Installation Prerequisites"
next:
  url: "install-rabbitmq"
  text: "Install RabbitMQ"
---

# Installation Prerequisites

As mentioned earlier in this guide, Sensu's [architecture](architecture) is one
of its most compelling features. While this modular design makes it infinitely
adaptable to monitor any infrastructure, it also depends on some external
services to function:

- [Transport](#transport)
- [Data Store (Redis)](#data-store)

_NOTE: this guide will focus on installing Sensu's dependencies in a
[standalone](installation-strategies#standalone) configuration. However, in a
live/production environment, it is strongly recommended that &ndash; at minimum
&ndash; the Sensu data store and transport run on a different system than the
Sensu server and API (i.e. in a [distributed](installation-strategies#\
distributed) or [high availability](installation-strategies#high-availability)
configuration). Please review the Sensu [Installation Strategies](installation-\
strategies) for more information._

## Transport {#sensu-transport}

Sensu services use a message bus (e.g. [RabbitMQ][rabbitmq]) for communication.
This message bus communication is provided by the [Sensu
Transport][sensu-transport], which is a library that makes it possible to
leverage alternate transport solutions in  place of RabbitMQ (the default
Transport). Sensu services requires access to the  same instance of the defined
Sensu Transport (e.g. a RabbitMQ cluster) to  function. Sensu check requests and
check results are published as "messages" to  the Sensu Transport, and the
corresponding Sensu services receive these messages  by subscribing to the
appropriate subscriptions.

### Available Transports

The Sensu Transport library makes it possible to replace Sensu's recommended and
default transport (RabbitMQ) with alternative solutions. There are currently
two (2) transports provided with the sensu-transport library: RabbitMQ and
Redis &mdash; each presenting unique performance and functional characteristics.

#### The RabbitMQ Transport

##### Pros {#rabbitmq-transport-pros}

- Native SSL support
- Pluggable authentication framework
- Support for ACLs

##### Cons {#rabbitmq-transport-cons}

- Adds Erlang as a runtime dependency to the Sensu architecture

#### The Redis Transport

##### Pros {#redis-transport-pros}

- Simplifies Sensu architecture by removing need for dedicated transport (by
  using Redis as the data store _and_ transport)

##### Cons {#redis-transport-cons}

- No native support for SSL

## Data Store (Redis) {#data-store}

[Redis][redis] is a key-value database, which [describes itself][redis-about] as
_"an open source, BSD licensed, advanced key-value cache and store"_. Sensu uses
Redis for storing persistent data such as the client registry and check results.
Two Sensu services, the server and API, require access to the same instance of
Redis to function (i.e. the Sensu client does not communicate with Redis).




[rabbitmq]:         https://www.rabbitmq.com/
[sensu-transport]:  https://github.com/sensu/sensu-transport
[redis]:            http://redis.io/
[redis-about]:      http://redis.io/topics/introduction
