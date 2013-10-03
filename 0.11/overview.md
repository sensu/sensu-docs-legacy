---
layout: default
title: Overview
description: Overview of Sensu
version: '0.11'
---

What is Sensu?
==============

<br />

Sensu is often described as the "monitoring router". Most simply put,
Sensu connects "check" scripts run across many nodes with "handler"
scripts run on one or more Sensu servers. [Checks](/{{ page.version }}/checks.html) 
are used, for example, to determine if Apache is up or down. 
[Checks](/{{ page.version }}/checks.html) can also be used to collect 
metrics (such as MySQL or Apache statistics). The output of 
[checks](/{{ page.version }}/checks.html) is routed to one or more 
[handlers](/{{ page.version }}/handlers.html). [Handlers](/{{ page.version }}/handlers.html) 
determine what to do with the results of [checks](/{{ page.version }}/checks.html). 
[Handlers](/{{ page.version }}/handlers.html) currently exist for sending 
alerts via email, as well as to various external services such as 
Pagerduty, IRC, Twitter, etc. [Handlers](/{{ page.version }}/handlers.html) 
can also feed metrics into Graphite, Librato, etc. Writing 
[checks](/{{ page.version }}/checks.html) and 
[handlers](/{{ page.version }}/handlers.html) is quite simple and 
can be done in any language.

Key details:

- Ruby (EventMachine, Sinatra, AMQP), RabbitMQ, Redis.
- Excellent test coverage with continuous integration via 
  [travis-ci](http://travis-ci.org/#!/sensu/sensu).
- Messaging oriented architecture. Messages are JSON objects.
- Ability to re-use existing Nagios plugins.
- Plugins and handlers (think notifications) can be written in any language.
- Supports sending metrics into various backends (Graphite, Librato, etc).
- Designed with modern configuration management systems such as Chef or Puppet in mind.
- Designed for cloud environments.
- Lightweight, less than 1200 lines of code.
- "Omnibus" style packages for easy, low-friction deployments!

Components
==========

The [Sensu platform](https://github.com/sensu/sensu) is made up of a number of components.

The Sensu server
------------

The Sensu server triggers clients to initiate checks, it then receives
the output of these checks and feeds it to [handlers](/{{ page.version }}/handlers.html). 
(As of version 0.9.2, clients can also execute checks that the server doesn't know
about and the server will still process their results, more on these
'standalone checks' elsewhere in the documentation. See 
[standalone checks](/{{ page.version }}/adding_a_standalone_check.html). )

The Sensu server relies on a Redis instance to keep persistent data. It also
relies heavily (as do most Sensu components) on access to RabbitMQ for
passing data between itself and Sensu client nodes.

The Sensu client
------------

The Sensu client runs on all of your systems that you want to monitor.
The Sensu client will execute check scripts (think `check_http`,
`check_load`, etc) and return the results from these checks to
the Sensu server via RabbitMQ.

The Sensu API
------------

A REST API that provides access to various pieces of data maintained on
the Sensu server (stored in Redis). You will typically run this on the same
host as your Sensu server or Redis instance. It is mostly used by
internal sensu components at this time.

The Sensu dashboard
---------------

Web dashboard providing an overview of the current state of your Sensu
infrastructure and the ability to perform actions, such as temporarily
silencing alerts.
