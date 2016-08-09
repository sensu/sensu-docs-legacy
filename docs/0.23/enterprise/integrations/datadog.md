---
title: "DataDog"
description: "Create DataDog events for Sensu events."
version: 0.23
weight: 18
---

**ENTERPRISE: Built-in integrations are available for [Sensu Enterprise][1]
users only.**

# DataDog Integration

- [Overview](#overview)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Integration Specification](#integration-specification)
    - [`datadog` attributes](#datadog-attributes)

## Overview

Create [Datadog][2] events for Sensu events. After [managing your Datadog
account API key][3], configure the handler (integration) with your API key.

## Configuration

### Example(s)

The following is an example global configuration for the `datadog` enterprise
event handler (integration).

~~~ json
{
  "datadog": {
    "api_key": "9775a026f1ca7d1c6c5af9d94d9595a4",
    "timeout": 10
  }
}
~~~

### Integration Specification

#### `datadog` attributes

The following attributes are configured within the `{"datadog": {} }`
[configuration scope][4].

`api_key`
: description
  : The Datadog account API key to use when creating Datadog events.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "api_key": "9775a026f1ca7d1c6c5af9d94d9595a4"
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

[1]:  /enterprise
[2]:  https://app.datadoghq.com/account/login?next=%2Faccount%2Fsettings#api
[3]:  https://app.datadoghq.com/account/login?next=%2Faccount%2Fsettings#api
[4]:  ../../reference/configuration.html#configuration-scopes
