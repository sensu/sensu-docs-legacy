---
title: "OpsGenie"
description: "Create and close OpsGenie alerts for Sensu events."
version: 1.0
weight: 5
---

**ENTERPRISE: Built-in integrations are available for [Sensu Enterprise][1]
users only.**

# OpsGenie Integration

- [Overview](#overview)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Integration Specification](#integration-specification)
    - [`opsgenie` attributes](#opsgenie-attributes)

## Overview

Create and close [OpsGenie][2] alerts for events.

## Configuration

### Example(s)

The following is an example global configuration for the `opsgenie` enterprise
event handler (integration).

~~~ json
{
  "opsgenie": {
    "api_key": "eed02a0d-85a4-427b-851a-18dd8fd80d93",
    "source": "Sensu Enterprise (AWS)",
    "teams": ["ops", "web"],
    "recipients": ["afterhours"],
    "tags": ["production"],
    "overwrites_quiet_hours": true,
    "timeout": 10
  }
}
~~~

### Integration Specification

#### `opsgenie` attributes

The following attributes are configured within the `{"opsgenie": {} }`
[configuration scope][3].

`api_key`
: description
  : The OpsGenie Alert API key to use when creating/closing alerts.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "api_key": "eed02a0d-85a4-427b-851a-18dd8fd80d93"
    ~~~

`source`
: description
  : The source to use for OpsGenie alerts.
: required
  : false
: type
  : String
: default
  : `Sensu Enterprise`
: example
  : ~~~ shell
    "source": "Sensu (us-west-1)"
    ~~~

`teams`
: description
  : An array of OpsGenie team names to be used to calculate which users will be responsible for created alerts.
: required
  : false
: type
  : Array
: default
  : `[]`
: example
  : ~~~ shell
    "teams": ["ops", "web"]
    ~~~

`recipients`
: description
  : An array of OpsGenie group, schedule, or escalation names to be used to calculate which users will be responsible for created alerts.
: required
  : false
: type
  : Array
: default
  : `[]`
: example
  : ~~~ shell
    "recipients": ["web", "afterhours"]
    ~~~

`tags`
: description
  : An array of OpsGenie alert tags that will be added to created alerts.
: required
  : false
: type
  : Array
: default
  : `[]`
: example
  : ~~~ shell
    "tags": ["production"]
    ~~~

`overwrites_quiet_hours`
: description
  : If events with a critical severity should be tagged with "OverwritesQuietHours". This tag can be used to bypass quiet (or off) hour alert notification filtering.
: required
  : false
: type
  : Boolean
: default
  : `false`
: example
  : ~~~ shell
    "overwrites_quiet_hours": true
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
[2]:  https://www.opsgenie.com?ref=sensu-enterprise
[3]:  ../../reference/configuration.html#configuration-scopes
