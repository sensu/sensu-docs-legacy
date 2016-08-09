---
title: "Graylog"
description: "Send Sensu events to Graylog via the Graylog Raw/Plaintext TCP
  input."
version: 0.24
weight: 10
---

**ENTERPRISE: Built-in integrations are available for [Sensu Enterprise][1]
users only.**

# Graylog Integration

- [Overview](#overview)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Integration Specification](#integration-specification)
    - [`graylog` attributes](#graylog-attributes)

## Overview

The integration sends event data to a [Graylog][2] [Raw/Plaintext TCP input][3].
This integration requires a Graylog [JSON extractor][4].

## Configuration

### Example(s)

The following is an example configuration for the `graylog` enterprise event
handler (integration).

~~~ json
{
  "graylog": {
    "host": "127.0.0.1",
    "port": 5555,
    "timeout": 10
  }
}
~~~

### Integration specification

#### `graylog` attributes


`host`
: description
  : The Graylog [Raw/Plaintext TCP input][3] host address.
: required
  : false
: type
  : String
: default
  : `127.0.0.1`
: example
  : ~~~ shell
    "host": "graylog.company.com"
    ~~~

`port`
: description
  : The Graylog [Raw/Plaintext TCP input][3] port.
: required
  : false
: type
  : Integer
: default
  : `5555`
: example
  : ~~~ shell
    "port": 5556
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
[2]:  https://www.graylog.org/
[3]:  http://docs.graylog.org/en/2.0/pages/sending_data.html#raw-plaintext-inputs
[4]:  http://docs.graylog.org/en/2.0/pages/extractors.html?highlight=json%20extractor#using-the-json-extractor
