---
version: 0.21
category: "Overview"
title: "What is Sensu?"
next:
  url: "installation-overview"
  text: "Installation Guide"
info:
warning:
danger:
---

# What is Sensu? {#what-is-sensu}

Sensu is often described as the "monitoring router". Essentially,
Sensu takes the results of "check" scripts run across many systems,
and if certain conditions are met, passes their information to one or
more "handlers". [Checks](checks) are used, for example, to determine
if a service like Apache is up or down. Checks can also be
used to collect data, such as MySQL query statistics or Rails
application metrics. [Handlers](handlers) take actions, using result
information, such as sending an email, messaging a chat room, or
adding a data point to a graph. There are several types of
handlers, but the most common and most powerful is "pipe",
a script that receives data via standard input. Check and
handler scripts can be written in any language, and the
[community
repository](https://github.com/sensu/sensu-community-plugins)
continues to grow!

Some Sensu features / design choices:

- Written in Ruby, using EventMachine
- Great test coverage with continuous integration via [Travis
CI](http://travis-ci.org/#!/sensu/sensu)
- Can use existing Nagios plugins
- Configuration all in JSON
- Has a message-oriented architecture, using RabbitMQ and JSON
payloads
- Packages are "omnibus", for consistency, isolation, and low-friction
deployment

Sensu embraces modern infrastructure design, works elegantly with
configuration management tools, and is built for the cloud.


# Components {#sensu-components}

The Sensu framework contains a number of components.

The following diagram depicts these core elements and how they
interact with one another.

![Sensu Diagram](img/sensu-diagram.gif)

## Dependencies {#sensu-dependencies}

All of the Sensu components require access to an instance of RabbitMQ
in order to communicate with each-other.

A few components require access to an instance of Redis for storing
persistent data.

## Server {#sensu-server}

Depends on: RabbitMQ, Redis

The Sensu server is responsible for orchestrating check executions,
processing check results, and handling events. You may run one
or more Sensu servers; tasks are distributed amongst them, and they
can be ephemeral. Servers will inspect every check result, saving some
of their information for a period of time. Check results that indicate
a service failure or contain data such as metrics, will have
additional context added to them, creating an [event](event_data). The
Sensu server passes events to [handlers](handlers).

## Client {#sensu-client}

Depends on: RabbitMQ

The Sensu client runs on all of your systems that you want to monitor.
The client receives check execution requests, executes the checks, and
publishes their results. Clients can also schedule their own check
executions, these are called "standalone" [checks](checks). The client
provides a local TCP and UDP socket for external check result input,
allowing applications to easily integrate with Sensu.

## API {#sensu-api}

Depends on: RabbitMQ, Redis

The Sensu API provides a REST-like interface to Sensu's data, such as
registered clients and current events. You may run one or more Sensu
APIs. The API is capable of many actions, such as issuing check
execution requests, resolving events, and removing a registered
client.
