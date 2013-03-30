---
layout: default
title: Overview
description: Overview of Sensu
version: 0.9
---

What is Sensu?
==============


Sensu is often described as the "monitoring router". Most simply put,
Sensu connects "check" scripts run across many nodes with "handler"
scripts run on one or more Sensu servers. Checks are used, for example,
to determine if Apache is up or down. Checks can also be used to collect
metrics (such as MySQL or Apache statistics). The output of checks is
routed to one or more handlers. Handlers determine what to do with the
results of checks. Handlers currently exist for sending alerts via
email, as well as to various external services such as Pagerduty, IRC,
Twitter, etc. Handlers can also feed metrics into Graphite, Librato,
etc. Writing checks and handlers is quite simple and can be done in any
language.

Key details:

- Ruby (EventMachine, Sinatra, AMQP), RabbitMQ, Redis
- Excellent test coverage with continuous integration via [travis-ci](http://travis-ci.org/#!/sonian/sensu)
- Messaging oriented architecture. Messages are JSON objects.
- Ability to re-use existing Nagios plugins
- Plugins and handlers (think notifications) can be written in any language
- Supports sending metrics into various backends (Graphite, Librato, etc)
- Designed with modern configuration management systems such as Chef or Puppet in mind
- Designed for cloud environments
- Lightweight, less than 1200 lines of code
- "Omnibus" style packages for easy, low-friction deployments!

Components
==========

The Sensu platform is made up of a number of components.

sensu-server
------------

The sensu-server triggers clients to initiate checks, it then receives
the output of these checks and feeds it to handlers. (As of version
0.9.2, clients can also execute checks that the server doesn't know
about and the server will still process their results, more on these
'standalone checks' in a future article.)

Sensu-server relies on a Redis instance to keep persistent data. It also
relies heavily (as do most sensu components) on access to rabbitmq for
passing data between itself and sensu-client nodes.

sensu-client
------------

The sensu-client runs on all of your systems that you want to monitor.
Sensu-client will execute check scripts (think `check_http`,
`check_load`, etc) and return the results from these checks to
sensu-server via rabbitmq.

sensu-api
------------

A REST API that provides access to various pieces of data maintained on
the sensu-server (in Redis). You will typically run this on the same
server as your sensu-server or Redis instance. It is mostly used by
internal sensu components at this time.

sensu-dashboard
---------------

Web dashboard providing an overview of the current state of your Sensu
infrastructure and the ability to perform actions, such as temporarily
silencing alerts.

