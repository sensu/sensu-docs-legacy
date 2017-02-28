---
title: "Graphite"
description: "Send metrics to the Graphite time-series database using the
  plaintext protocol."
version: 0.28
weight: 17
---

**ENTERPRISE: Built-in integrations are available for [Sensu Enterprise][1]
users only.**

# Graphite Integration

- [Overview](#overview)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Integration Specification](#integration-specification)
    - [`graphite` attributes](#graphite-attributes)

## Overview

Send metrics to [Graphite][2], using the plaintext protocol over TCP. The
`graphite` enterprise handler is also capable of sending metrics to [Hosted
Graphite][3], using the `prefix` attribute to prefix metric names with the
Hosted Graphite API key. This handler uses the `output_format` mutator.

## Configuration

### Example(s)

The following is an example global configuration for the `graphite` enterprise
handler (integration).

~~~ json
{
  "graphite": {
    "host": "graphite.example.com",
    "port": 2003,
    "prefix_source": false,
    "prefix": "production"
  }
}
~~~

### Integration Specification

#### `graphite` attributes

The following attributes are configured within the `{"graphite": {} }`
[configuration scope][4].

`host`
: description
  : The Graphite Carbon host address.
: required
  : false
: type
  : String
: default
  : `127.0.0.1`
: example
  : ~~~ shell
    "host": "carbon.hostedgraphite.com"
    ~~~

`port`
: description
  : The Graphite Carbon port.
: required
  : false
: type
  : Integer
: default
  : `2003`
: example
  : ~~~ shell
    "port": 3003
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
  : A custom metric name prefix - this can be used to prefix the Hosted Graphite
    API key.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "prefix": "production"
    ~~~


[?]:  #
[1]:  /enterprise
[2]:  http://graphite.wikidot.com?ref=sensu-enterprise
[3]:  https://www.hostedgraphite.com?ref=sensu-enterprise
[4]:  ../../reference/configuration.html#configuration-scopes
