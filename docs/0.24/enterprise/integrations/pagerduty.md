---
title: "PagerDuty"
version: 0.24
weight: 2
---

**ENTERPRISE: Built-in integrations are available for [Sensu Enterprise][1]
users only.**

# PagerDuty Integration

- [Overview](#overview)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Integration specification](#integration-specification)
    - [`pagerduty` attributes](#pagerduty-attributes)

## Overview

Create and resolve [PagerDuty][2] incidents for events. After [configuring a
service in PagerDuty][3], configure the handler (integration) with the provided
service key.

## Configuration

### Example(s)

The following is an example global configuration for the `pagerduty` enterprise
event handler (integration).

~~~ json
{
  "pagerduty": {
    "service_key": "r3FPuDvNOTEDyQYCc7trBkymIFcy2NkE",
    "timeout": 10
  }
}
~~~

### Integration Specification

#### `pagerduty` attributes

The following attributes are configured within the `{"pagerduty": {} }`
[configuration scope][4].

`service_key`
: description
  : The PagerDuty service key to use when creating and resolving incidents.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "service_key": "r3FPuDvNOTEDyQYCc7trBkymIFcy2NkE"
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
[1]:  https://support.pagerduty.com/hc/en-us/articles/202830340-Creating-a-Generic-API-Service
[2]:  https://www.pagerduty.com?ref=sensu-enterprise
[3]:  https://support.pagerduty.com/hc/en-us/articles/202830340-Creating-a-Generic-API-Service?ref=sensu-enterprise
[4]:  ../../reference/configuration.html#configuration-scopes
