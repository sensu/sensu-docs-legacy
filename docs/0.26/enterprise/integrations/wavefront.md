---
title: "Wavefront"
description: "Send metrics to Wavefront using the Wavefront Data Format."
version: 0.26
weight: 18
---

**ENTERPRISE: Built-in integrations are available for [Sensu Enterprise][1]
users only.**

# Wavefront Integration

- [Overview](#overview)
- [Configuring a Wavefront Proxy](#configuring-a-wavefront-proxy)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Integration Specification](#integration-specification)
    - [`wavefront` attributes](#wavefront-attributes)

## Overview

Send metrics to [Wavefront][2] using the [Wavefront Data Format][4]. This
handler uses the `output_format` mutator.

## Configuring a Wavefront Proxy

To install and configure a Wavefront Proxy to receive metrics from Sensu
Enterprise, please refer to the [Wavefront Proxy setup documentation][5].

## Configuration

### Example(s)

The following is an example global configuration for the `wavefront` enterprise
handler (integration).

~~~ json
{
  "wavefront": {
    "host": "wavefront.example.com",
    "port": 2878
  }
}
~~~

### Integration Specification

#### `wavefront` attributes

The following attributes are configured within the `{"wavefront": {} }`
[configuration scope][3].

`host`
: description
  : The Wavefront host address.
: required
  : false
: type
  : String
: default
  : `127.0.0.1`
: example
  : ~~~ shell
    "host": "wavefront.example.com"
    ~~~

`port`
: description
  : The Wavefront Proxy port for the Wavefront Data Format.
: required
  : false
: type
  : Integer
: default
  : `2878`
: example
  : ~~~ shell
    "port": 2878
    ~~~


[1]:  /enterprise
[2]:  http://www.wavefront.com?ref=sensu-enterprise
[3]:  ../../reference/configuration.html#configuration-scopes
[4]:  https://community.wavefront.com/docs/DOC-1031
[5]:  https://community.wavefront.com/docs/DOC-1041
