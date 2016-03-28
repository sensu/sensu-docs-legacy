---
version: 0.22
category: "Installation Guide"
title: "Installation Prerequisites"
next:
  url: "install-redis"
  text: "Install Redis"
---

# Installation Prerequisites

As mentioned earlier in this guide, Sensu's [architecture][1] is one
of its most compelling features. While this modular design makes it infinitely
adaptable to monitor any infrastructure, it also depends on some external
services to function:

- [Data Store (Redis)](#data-store)
- [Transport](#transport)

_NOTE: this guide will focus on installing Sensu's dependencies in a
[standalone][2] configuration. However, in a live/production environment, it is
strongly recommended that &ndash; at minimum &ndash; the Sensu data store and
transport run on a different system than the Sensu server and API (i.e. in a
[distributed][3] or [high availability][4] configuration). Please review the
Sensu [Installation Strategies][5] for more information._

## Data Store (Redis) {#data-store}

Sensu uses [Redis][6] as a [data-store][7] for storing persistent data such as the
client registry and check results. Two Sensu Core services, the server and API
require access to the same instance of Redis to function (i.e. the Sensu client
does not communicate with Redis).

## Transport {#sensu-transport}

Sensu services use a message bus (e.g. [RabbitMQ][8]) for communication. This
message bus communication is provided by the [Sensu Transport][9], which is a
library that makes it possible to leverage alternate transport solutions in
place of RabbitMQ (the default transport). Sensu services requires access to the
same instance of the defined transport (e.g. a RabbitMQ cluster) to  function.
Sensu check requests and check results are published as "messages" to  the Sensu
Transport, and the corresponding Sensu services receive these messages  by
subscribing to the appropriate subscriptions.

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

- Adds Erlang as a runtime dependency to the Sensu architecture (only on systems
  where RabbitMQ is running)

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


[1]:  architecture
[2]:  installation-strategies#standalone
[3]:  installation-strategies#distributed
[4]:  installation-strategies#high-availability
[5]:  installation-strategies
[6]:  http://redis.io
[7]:  data-store
[8]:  rabbitmq
[9]:  transport
