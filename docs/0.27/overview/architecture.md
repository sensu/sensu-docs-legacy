---
layout: "docs"
version: 0.27
weight: 3
title: "Sensu Architecture"
next:
  url: "../installation/overview.html"
  text: "Installation Guide"
info:
warning:
danger:
---

# Sensu Architecture

## Architectural Overview

One of advantages that Sensu provides over other monitoring solutions is its
architecture, which facilitates the execution of service checks, collection of
metric data, and event processing at scale. This architecture is comprised of
the following components:

- [Secure Transport](#secure-transport)
- [Data Store](#data-store)
- [Check Execution Scheduler](#check-execution-scheduler)
- [Monitoring Agent](#monitoring-agent)
- [Event Processor](#event-processor)
- [RESTful API](#restful-api)

### Architectural Diagram

![](/docs/0.27/img/sensu-diagram.gif)

### Secure Transport

Sensu services use a message bus (e.g. [RabbitMQ][1]) to communicate with
one another (technically speaking, the Sensu services don’t actually communicate
with each other – they only communicate with the message bus). As of Sensu Core
version 0.13 this message bus communication in Sensu has been abstracted as the
[Sensu Transport][2], making it possible to leverage alternate
transport solutions in  place of RabbitMQ (the default Transport). Sensu
services requires access to the  same instance of the defined Sensu Transport
(e.g. a RabbitMQ cluster) to  function. Sensu check requests and check results
are published as "messages" to  the Sensu Transport, and the corresponding Sensu
services receive these messages  by subscribing to the appropriate
subscriptions.

### Data Store

Sensu leverages a [data store][3] for data persistence. Only the Sensu server,
API, and dashboard services require access to the data store &mdash; the [Sensu
client][4] (monitoring agent) does not. By storing data in Redis, the Sensu
services themselves can remain stateless. Although Sensu is designed to route
telemetry data to external time-series databases (e.g. [Graphite][5],
[Librato][6], [InfluxDB][7], etc), Sensu does store the following state data:

- [Client registry][8]
- Check history
- Event registry
- Stashes (a key-value store provided by the [Sensu API][9])

### Check Execution Scheduler

Sensu offers two distinct check execution schedulers: the Sensu server, and the
Sensu client (monitoring agent). The Sensu server schedules and publishes check
execution requests to client subscriptions (via a Publish/Subscribe model). The
Sensu client (monitoring agent) schedules and executes "standalone" checks (on
the local system only). Sensu's execution schedulers are not mutually exclusive,
so monitoring checks may be configured for both of Sensu's schedulers (the Sensu
server and Sensu client), and Sensu will ensure that the corresponding checks
are executed on the appropriate systems.

### Monitoring Agent

The Sensu client is a fully featured monitoring agent which provides the
following features:

- dynamic self-registration
- client subscriptions (for monitoring checks configured via the
  Publish/Subscribe model)
- a local [check execution scheduler][10]
- an execution platform for monitoring the local system & services and/or
  external resources
- an input socket for accepting input from external services.

### Event Processor

The Sensu server is a scalable event processor that processes event data and
takes action. Sensu's event processing capabilities include:

- Registering and de-registering clients
- Processing check results
- Processing monitoring events using [filters][11], [mutators][12], and
  [handlers][13]

Sensu's event processor is designed to scale along with the applications and
infrastructure it is monitoring. Although Event Handlers are executed locally by
the Sensu server, multiple instances of the Sensu server can be run without any
additional configuration. Sensu provides built-in leader election to avoid
scheduling conflicts between Sensu servers, and the Sensu [transport][14]
distributes (via round-robin) check results between Sensu servers for
processing, which provides load-balancing.

### RESTful API

Sensu provides access to monitoring data and core functionality via a RESTful
HTTP JSON API, including:

- A [Clients API][15] for accessing Client data and adding/removing clients
- A [Checks API][16] for accessing Check configuration data and publishing check
  requests
- An [Events API][17] for accessing event data and resolving events
- A [Results API][18] for accessing check result data and publishing check
  results
- An [Aggregates API][19] for accessing aggregated check result data and
  deleting aggregate data
- A [Stashes API][20] for providing read/write access to Redis' underlying
  key-value functionality


[1]:  http://www.rabbitmq.com/
[2]:  http://github.com/sensu/sensu-transport
[3]:  ../reference/data-store.html
[4]:  ../reference/clients.html
[5]:  https://github.com/graphite-project
[6]:  https://www.librato.com/
[7]:  https://influxdata.com/
[8]:  ../reference/clients.html#registration-and-registry
[9]:  ../api/overview.html
[10]: #check-execution-scheduler
[11]: ../reference/filters.html
[12]: ../reference/mutators.html
[13]: ../reference/handlers.html
[14]: ../reference/transport.html
[15]: ../api/clients-api.html
[16]: ../api/checks-api.html
[17]: ../api/events-api.html
[18]: ../api/results-api.html
[19]: ../api/aggregates-api.html
[20]: ../api/stashes-api.html
