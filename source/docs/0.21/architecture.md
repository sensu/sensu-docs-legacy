---
version: 0.21
category: "Architecture"
title: "Technical Overview"
next:
  url: "installation-overview"
  text: "Installation Guide"
info:
warning:
danger:
---

# Technical Overview

One of advantages Sensu provides over other monitoring solutions is its
architecture, which facilitates the execution of service checks, collection of
metric data, and event processing at scale. This architecture is comprised of
the following components:

- [Secure Transport](#transport)
- [Data Store](#data-store)
- [Check Execution Scheduler](#check-execution-scheduler)
- [Monitoring Agent](#monitoring-agent)
- [Event Processor](#event-processor)
- [RESTful API](#restful-api)

## Secure Transport

Sensu services use a message bus (e.g. [RabbitMQ][rabbitmq]) to communicate with
one another (technically speaking, the Sensu services don’t actually communicate
with each other – they only communicate with the message bus). As of Sensu Core
version 0.13 this message bus communication in Sensu has been abstracted as the
[Sensu Transport][sensu-transport], making it possible to leverage alternate
transport solutions in  place of RabbitMQ (the default Transport). Sensu
services requires access to the  same instance of the defined Sensu Transport
(e.g. a RabbitMQ cluster) to  function. Sensu check requests and check results
are published as "messages" to  the Sensu Transport, and the corresponding Sensu
services receive these messages  by subscribing to the appropriate
subscriptions.

## Data Store

Sensu leverages a data store ([Redis][redis]) for data persistence. Only the
Sensu server, API, and dashboard services require access to the data store - the
Sensu client (monitoring agent) does not. By storing data in Redis, the Sensu
services themselves can remain stateless. Although Sensu is designed to route
telemetry data to external time-series databases (e.g. [Graphite][graphite],
[Librato][librato], [InfluxDB][influxdb], etc), Sensu does store the following
state data:

- client registry
- event registry
- check history
- stashes (exposing the underlying Redis key-value store via the Sensu API)

## Check Execution Scheduler

Sensu offers two distinct check execution schedulers: the Sensu server, and the
Sensu client (monitoring agent). The Sensu server schedules and publishes check
execution requests to client subscriptions (via a Publish/Subscribe model). The
Sensu client (monitoring agent) schedules and executes "standalone" checks (on
the local system only). Sensu's execution schedulers are not mutually exclusive,
so monitoring checks may be configured for both of Sensu's schedulers (the Sensu
server and Sensu client), and Sensu will ensure that the corresponding checks
are executed on the appropriate systems.

## Monitoring Agent

The Sensu client is a fully featured monitoring agent which provides the
following features:

- dynamic self-registration
- client subscriptions (for monitoring checks configured via the
  Publish/Subscribe model)
- a local [check execution scheduler][scheduler]
- an execution platform for monitoring the local system & services and/or
  external resources
- an input socket for accepting input from external services.

## Event Processor

The Sensu server is a scalable event processor that processes event data and
takes action. Sensu's event processing capabilities include:

- Registering and de-registering clients
- Processing check results
- Processing monitoring events using [filters][filters], [mutators][mutators],
  and [handlers][handlers]

Sensu's event processor is designed to scale along with the applications and
infrastructure it is monitoring. Although Event Handlers are executed locally by
the Sensu server, multiple instances of the Sensu server can be run without any
additional configuration. Sensu provides built-in leader election to avoid
scheduling conflicts between Sensu servers, and the Sensu [transport][transport]
distributes (via round-robin) check results between Sensu servers for
processing, which provides load-balancing.

## RESTful API

Sensu provides access to monitoring data and core functionality via a RESTful
HTTP JSON API, including:

- A [Clients API][clients-api] for accessing Client data and adding/removing
  clients
- A [Checks API][checks-api] for accessing Check configuration data and
  publishing check requests
- An [Events API][events-api] for accessing event data and resolving events
- A [Results API][results-api] for accessing check result data and publishing
  check results
- An [Aggregates API][aggregates-api] for accessing aggregated check result data
  and deleting aggregate data
- A [Stashes API][stashes-api] for providing read/write access to Redis'
  underlying key-value functionality



[rabbitmq]:           http://www.rabbitmq.com/
[sensu-transport]:    http://github.com/sensu/sensu-transport
[redis]:              http://redis.io/
[graphite]:           https://github.com/graphite-project
[librato]:            https://www.librato.com/
[influxdb]:           https://influxdata.com/
[scheduler]:          #check-execution-scheduler
[filters]:            filters
[mutators]:           mutators
[handlers]:           handlers
[clients-api]:        api-clients
[checks-api]:         api-checks
[events-api]:         api-events
[results-api]:        api-results
[aggregates-api]:     api-aggregates
[stashes-api]:        api-stashes
