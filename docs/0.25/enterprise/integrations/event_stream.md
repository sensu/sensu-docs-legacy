---
title: "Event Stream"
description: "Send Sensu events to a remote TCP socket for complex event
  processing and/or long-term storage."
version: 0.25
weight: 15
---

**ENTERPRISE: Built-in integrations are available for [Sensu Enterprise][1]
users only.**

# Event Stream Integration

- [Overview](#overview)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Integration Specification](#integration-specification)
    - [`event_stream` attributes](#eventstream-attributes)

## Overview

The event stream integrations sends **all** [Sensu events][2] to a remote TCP
socket for [complex event processing][3] (or "stream processing") and/or
long-term storage.

## Configuration

### Example(s)

The following is an example configuration for the `event_stream` enterprise
event handler (integration).

~~~ json
{
  "event_stream": {
    "host": "127.0.0.1",
    "port": 3000,
    "filter_metrics": false
  }
}
~~~


### Integration specification

#### `event_stream` attributes


`host`
: description
  : The remote host address.
: required
  : false
: type
  : String
: default
  : `127.0.0.1`
: example
  : ~~~ shell
    "host": "moogserver-01.company.com"
    ~~~

`port`
: description
  : The remote TCP port.
: required
  : false
: type
  : Integer
: default
  : `3000`
: example
  : ~~~ shell
    "port": 3333
    ~~~

`filter_metrics`
: description
  : If [events][2] with a `type` of `metric` are relayed to the remote socket.
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
[2]:  ../../reference/events.html
[3]:  https://en.wikipedia.org/wiki/Complex_event_processing
