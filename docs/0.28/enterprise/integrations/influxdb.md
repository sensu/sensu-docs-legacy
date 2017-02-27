---
title: "InfluxDB"
version: 0.27
weight: 16
---

**ENTERPRISE: Built-in integrations are available for [Sensu Enterprise][1]
users only.**

# InfluxDB Integration

- [Overview](#overview)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Integration Specification](#integration-specification)
    - [`influxdb` attributes](#influxdb-attributes)

## Overview

Send metrics to [InfluxDB][2] using the InfluxDB HTTP API.

## Configuration

### Example(s)

The following is an example global configuration for the influxdb enterprise
handler (integration).

~~~ json
{
  "influxdb": {
    "host": "8.8.8.8",
    "port": 8086,
    "username": "root",
    "password": "Bfw3Bdrn5WfqvOl1",
    "api_version": "0.9"
  }
}
~~~

### Integration specification

#### `influxdb` attributes

The following attributes are configured within the `{"influxdb": {} }`
[configuration scope][3].

`host`
: description
  : The InfluxDB host address.
: required
  : false
: type
  : String
: default
  : `127.0.0.1`
: example
  : ~~~ shell
    "host": "8.8.8.8"
    ~~~

`port`
: description
  : The InfluxDB HTTP API port.
: required
  : false
: type
  : Integer
: default
  : `8086`
: example
  : ~~~ shell
    "port": 9096
    ~~~

`username`
: description
  : The InfluxDB username.
: required
  : false
: type
  : String
: default
  : `root`
: example
  : ~~~ shell
    "username": "sensu"
    ~~~

`password`
: description
  : The InfluxDB user password.
: required
  : false
: type
  : String
: default
  : `root`
: example
  : ~~~ shell
    "password": "secret"
    ~~~

`database`
: description
  : The InfluxDB database (name) to use.
: required
  : false
: type
  : String
: default
  : `db`
: example
  : ~~~ shell
    "database": "sensu"
    ~~~

`api_version`
: description
  : The InfluxDB API version.
: required
  : false
: type
  : String
: allowed values
  : `0.8`, `0.9`
: default
  : `0.8`
: example
  : ~~~ shell
    "api_version": "0.9"
    ~~~

`timeout`
: description
  : The InfluxDB HTTP API POST timeout (write).
: required
  : false
: type
  : Integer
: default
  : `10`
: example
  : ~~~ shell
    "timeout": 3
    ~~~


[1]:  /enterprise
[2]:  https://influxdata.com?ref=sensu-enterprise
[3]:  ../../reference/configuration.html#configuration-scopes
