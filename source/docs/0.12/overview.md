---
version: "0.12"
category: "Overview"
title: "Overview of Sensu"
next:
  url: installing_sensu
  text: "Installing Sensu"
---

# What is Sensu?

Sensu is often described as the "monitoring router". Essentially,
Sensu takes the results of "check" scripts run across many machines,
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
- Uses a message-oriented architecture, using RabbitMQ and JSON
payloads.
- Packages are "Omnibus", for consistency, isolation, and low-friction
deployment.

Sensu is designed for modern infrastructures and to be driven by
configuration management tools, designed for the "cloud".

## Components

The Sensu framework is made up of a number of components.

## The Sensu server

The Sensu server triggers clients to initiate checks, it then receives
the output of these checks and feeds it to [handlers](handlers). (As of version
0.9.2, clients can also execute checks that the server doesn't know about and
the server will still process their results, more on these 'standalone checks'
elsewhere in the documentation. See
[standalone checks](adding_a_standalone_check)).

The Sensu server relies on a Redis instance to keep persistent data. It also
relies heavily (as do most Sensu components) on access to RabbitMQ for
passing data between itself and Sensu client nodes.

## The Sensu client

The Sensu client runs on all of your systems that you want to monitor.
The Sensu client will execute check scripts (think `check_http`,
`check_load`, etc) and return the results from these checks to
the Sensu server via RabbitMQ.

## The Sensu API

A REST API that provides access to various pieces of data maintained on
the Sensu server (stored in Redis). You will typically run this on the same
host as your Sensu server or Redis instance. It is mostly used by
internal sensu components at this time.

## The Sensu dashboard

Web dashboard providing an overview of the current state of your Sensu
infrastructure and the ability to perform actions, such as temporarily
silencing alerts.
