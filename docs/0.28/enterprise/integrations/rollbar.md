---
title: "Rollbar"
version: 0.28
weight: 2
---

**ENTERPRISE: Built-in integrations are available for [Sensu Enterprise][1]
users only.**

# Rollbar Integration

- [Overview](#overview)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Integration specification](#integration-specification)
    - [`rollbar` attributes](#rollbar-attributes)

## Overview

Create and resolve [Rollbar][2] messages/items for [Sensu events][3].

## Configuration

### Example(s)

The following is an example global configuration for the `rollbar` enterprise
event handler (integration).

~~~ json
{
  "rollbar": {
    "access_token_read": "2ae6bccccf534b9c8749a4327671e711",
    "access_token_write": "944872fdbfba40c48305fc8cd73707b5",
    "access_token_patch": "f34948101a714661a83dcd8dbe6a167a",
    "timeout": 30
  }
}
~~~

### Integration Specification

#### `rollbar` attributes

The following attributes are configured within the `{"rollbar": {} }`
[configuration scope][4].

`access_token_read`
: description
  : The Rollbar access token for read operations.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "access_token_read": "2ae6bccccf534b9c8749a4327671e711"
    ~~~

`access_token_write`
: description
  : The Rollbar access token for write operations.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "access_token_write": "944872fdbfba40c48305fc8cd73707b5"
    ~~~

`access_token_patch`
: description
  : The Rollbar access token for patch operations.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "access_token_patch": "f34948101a714661a83dcd8dbe6a167a"
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
[2]:  https://rollbar.com/
[3]:  ../../reference/events.html
[4]:  ../../reference/configuration.html#configuration-scopes
