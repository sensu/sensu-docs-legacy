---
title: "Librato"
description: "Send metrics to Librato using the Librato HTTP API."
version: 0.24
weight: 17
---

**ENTERPRISE: Built-in integrations are available for [Sensu Enterprise][1]
users only.**

# Librato Integration

- [Overview](#overview)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Integration Specification](#integration-specification)
    - [`librato` attributes](#librato-attributes)

## Overview

Send metrics to [Librato][2] Metrics using the HTTP API.

## Configuration

### Example(s)

The following is an example global configuration for the `librato` enterprise
handler (integration).

~~~ json
{
  "librato": {
    "email": "support@example.com",
    "api_key": "90SHpjPOFqd2YJFIX9rzDq7ik6CiDmqu2AvqcXJAX3buIwcOGqIOgNilwKMjpStO"
  }
}
~~~

### Integration Specification

#### `librato` attributes

The following attributes are configured within the `{"librato": {} }`
[configuration scope][3].

`email`
: description
  : The Librato account email.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "email": "support@example.com"
    ~~~

`api_key`
: description
  : The Librato account API key.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "api_key": "90SHpjPOFqd2YJFIX9rzDq7ik6CiDmqu2AvqcXJAX3buIwcOGqIOgNilwKMjpStO"
    ~~~


[?]:  #
[1]:  /enterprise
[2]:  https://www.librato.com?ref=sensu-enterprise
[3]:  ../../reference/configuration.html#configuration-scopes
