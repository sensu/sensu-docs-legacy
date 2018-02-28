---
title: "VictorOps"
version: 0.28
weight: 4
---

**ENTERPRISE: Built-in integrations are available for [Sensu Enterprise][1]
users only.**

# VictorOps Integration

- [Overview](#overview)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Integration Specification](#integration-specification)
    - [`victorops` attributes](#victorops-attributes)

## Overview

Create [VictorOps][2] messages for events.

## Configuration

### Example(s)

The following is an example global configuration for the `victorops` enterprise
event handler (integration).

~~~ json
{
  "victorops": {
    "api_key": "a53265cd-d2ef-fa32-fc54de52659a",
    "routing_key": "everyone",
    "timeout": 10
  }
}
~~~

### Integration Specification

#### `victorops` attributes

The following attributes are configured within the `{"victorops": {} }`
[configuration scope][3].

`api_key`
: description
  : The VictorOps api key to use when creating messages.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "api_key": "a53265cd-d2ef-fa32-fc54de52659a"
    ~~~

`routing_key`
: description
  : The VictorOps routing key to decide what team(s) to send alerts to.
: required
  : false
: type
  : String
: default
  : `everyone`
: example
  : ~~~ shell
    "routing_key": "ops"
    ~~~

`filters`
: description
  : An array of Sensu event filters (names) to use when filtering events for the
    handler. Each array item must be a string. Specified filters are merged with
    default values.
: required
  : false
: type
  : Array
: default
  : ~~~ shell
    ["handle_when", "check_dependencies"]
    ~~~
: example
  : ~~~ shell
    "filters": ["recurrence", "production"]
    ~~~

`severities`
: description
  : An array of check result severities the handler will handle.
    _NOTE: event resolution bypasses this filtering._
: required
  : false
: type
  : Array
: allowed values
  : `ok`, `warning`, `critical`, `unknown`
: example
  : ~~~ shell
    "severities": ["critical", "unknown"]
    ~~~

`timeout`
: description
  : The handler execution duration timeout in seconds (hard stop).
: required
  : false
: type
  : Integer
: default
  : `10`
: example
  : ~~~ shell
    "timeout": 30
    ~~~

[?]:  #
[1]:  /enterprise
[2]:  https://victorops.com?ref=sensu-enterprise
[3]:  ../../reference/configuration.html#configuration-scopes
