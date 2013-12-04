---
version: "0.12"
category: "Overview"
title: "Overview of Sensu"
next:
  url: packages
  text: "Sensu packages"
---

# What is Sensu?

Sensu is often described as the "monitoring router". Essentially,
Sensu takes the results of "check" scripts run across many systems,
and if certain conditions are met; passes their information to one or
more "handlers". [Checks](checks) are used, for example, to determine
if a service like Apache is up or down. [Checks](checks) can also be
used to collect data, such as MySQL query statistics or Rails
application metrics. [Handlers](handlers) take actions, using result
information, such as sending an email, messaging a chat room, or
adding a data point to a graph. There are several types of
[handlers](handlers), but the most common and most powerful is "pipe",
a script that receives data via standard input. [Check](checks) and
[handler](handlers) scripts can be written in any language, and the
[community
repository](https://github.com/sensu/sensu-community-plugins)
continues to grow!

Fun Sensu facts:

- Written in Ruby, using EventMachine.
- Has great test coverage with continuous integration via [Travis
CI](http://travis-ci.org/#!/sensu/sensu).
- Can use existing Nagios plugins.
- Configuration is all in JSON.
- Has a message-oriented architecture, using RabbitMQ and JSON
payloads.
- Packages are "omnibus", for consistency, isolation, and low-friction
deployment.

Sensu is designed for modern infrastructures and to be driven by
configuration management tools, designed for the "cloud".


# Components

The Sensu framework is made up of a number of components.

The following is a diagram of the core components and how they
interact with one another.

![Sensu Diagram](img/sensu-diagram.png)

## Dependencies

All of the Sensu components require access to an instance of RabbitMQ,
in order to communicate with each-other.

A few components require access to an instance of Redis, for storing
persistent data.

## Server

Depends on: RabbitMQ, Redis

The Sensu server is responsible for orchestrating check executions,
the processing of check results, and event handling. You may run one
or more Sensu servers, tasks are distributed amongst them, and they
can be ephemeral. Servers will inspect every check result, saving some
of their information for a period of time. Check results that indicate
a service failure or contain data such as metrics, will have
additional context added to them, creating an [event](events). The
Sensu server passes [events](events) to [handlers](handlers).

## Client

Depends on: RabbitMQ

The Sensu client runs on all of your systems that you want to monitor.
The client receives check execution requests, executes the checks, and
publishes their results. Clients can also schedule their own check
executions, these are called "standalone" [checks](checks). The client
provides a local TCP and UDP socket for external check result input,
allowing applications to easily integrate with Sensu.

## API

Depends on: RabbitMQ, Redis

The Sensu API provides a REST-like interface to Sensu's data, such as
registered clients and current events. You may run one or more Sensu
APIs. The API is capable of many actions, such as issuing check
execution requests, resolving events, and removing a registered
clients.

## Dashboard

Depends on: API

The Sensu dashboard is a web based dashboard, providing an overview of
the health of your monitored infrastructure. The dashboard only
communicates with the Sensu API, exposing its features/abilities, with
a human friendly interface. The Sensu dashboard is not part of the
Sensu "core", as it's common to create custom dashboards, however, it
is included in the Sensu package.
