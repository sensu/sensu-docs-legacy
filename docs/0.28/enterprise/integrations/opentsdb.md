---
title: "OpenTSDB"
description: "Send metrics to OpenTSDB using the telnet protocol."
version: 0.28
weight: 19
---

**ENTERPRISE: Built-in integrations are available for [Sensu Enterprise][1]
users only.**

# OpenTSDB Integration

- [Overview](#overview)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Integration Specification](#integration-specification)
    - [`opentsdb` attributes](#opentsdb-attributes)

## Overview

Send metrics to [OpenTSDB][2] using the telnet protocol (over TCP). This
handler uses the `output_format`mutator.

## Configuration

### Example(s)

The following is an example global configuration for the `opentsdb` enterprise
handler (integration).

~~~ json
{
  "opentsdb": {
    "host": "opentsdb.example.com",
    "port": 4242,
    "tag_host": true
  }
}
~~~

### Integration Specification

#### `opentsdb` attributes

The following attributes are configured within the `{"opentsdb": {} }`
[configuration scope][3].

`host`
: description
  : The OpenTSDB host address.
: required
  : false
: type
  : String
: default
  : `127.0.0.1`
: example
  : ~~~ shell
    "host": "opentsdb.example.com"
    ~~~

`port`
: description
  : The OpenTSDB telnet listener port.
: required
  : false
: type
  : Integer
: default
  : `4242`
: example
  : ~~~ shell
    "port": 4444
    ~~~

`tag_host`
: description
  : If automatic host tagging should be used for metric data points. The Sensu
    client `name` is used as the `host` tag value. The OpenTSDB handler will
    always add a `host` tag to metric data points that do not have tags.
: required
  : false
: type
  : Boolean
: default
  : `true`
: example
  : ~~~ shell
    "tag_host": false
    ~~~

`prefix_source`
: description
  : If the Sensu source (client name) should prefix (added to) the metric names.
: required
  : false
: type
  : Boolean
: default
  : `false`
: example
  : ~~~ shell
    "prefix_source": true
    ~~~

`prefix`
: description
  : A custom metric name prefix.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "prefix": "production"
    ~~~

[1]:  /enterprise
[2]:  http://opentsdb.net?ref=sensu-enterprise
[3]:  ../../reference/configuration.html#configuration-scopes
