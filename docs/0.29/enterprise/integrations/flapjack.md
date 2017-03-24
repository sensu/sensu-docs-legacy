---
title: "Flapjack"
description: "Relay Sensu results to Flapjack for notification routing and event
  processing."
version: 0.29
weight: 11
---

# Flapjack Integration

**ENTERPRISE: Built-in integrations are available for [Sensu Enterprise][1]
users only.**

- [Overview](#overview)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Integration Specification](#integration-specification)
    - [`flapjack` attributes](#flapjack-attributes)

## Overview

Relay Sensu results to [Flapjack][2], a monitoring notification routing and
event processing system. Flapjack uses Redis for event queuing; this integration
sends event data to Flapjack through Redis, using the Flapjack event format.

_NOTE: checks **DO NOT** need to specify `flapjack` as an event handler, as
every check result will be relayed to Flapjack if the integration is
configured._

## Configuration

### Example(s)

The following is an example global configuration for the `flapjack` enterprise
integration.

~~~ json
{
  "flapjack": {
    "host": "redis.example.com",
    "port": 6379,
    "db": 0,
    "channel": "events",
    "filter_metrics": false
  }
}
~~~

### Integration Specification

#### `flapjack` attributes

The following attributes are configured within the `{"flapjack": {} }`
[configuration scope][3].

`host`
: description
  : The Flapjack Redis instance address.
: required
  : false
: type
  : String
: default
  : `127.0.0.1`
: example
  : ~~~ shell
    "host": "8.8.8.8"
    ~~~

`port`
: description
  : The Flapjack Redis instance port.
: required
  : false
: type
  : Integer
: default
  : `6379`
: example
  : ~~~ shell
    "port": 6380
    ~~~

`db`
: description
  : The Flapjack Redis instance database (#) to use.
: required
  : false
: type
  : Integer
: default
  : `0`
: example
  : ~~~ shell
    "db": 1
    ~~~

`channel`
: description
  : The Flapjack Redis instance channel (queue) to use for events.
: required
  : false
: type
  : String
: default
  : `events`
: example
  : ~~~ shell
    "channel": "flapjack"
    ~~~

`filter_metrics`
: description
  : If check results with a `type` of `metric` are relayed to Flapjack.
: required
  : false
: type
  : Boolean
: default
  : `false`
: example
  : ~~~ shell
    "filter_metrics": true
    ~~~

[1]:  /enterprise
[2]:  http://flapjack.io?ref=sensu-enterprise
[3]:  ../../reference/configuration.html#configuration-scopes
