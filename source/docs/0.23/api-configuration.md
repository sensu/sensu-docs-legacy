---
version: 0.23
category: "API Docs"
title: "API Configuration"
---

# Sensu API Configuration

The Sensu API provides several endpoints to access Sensu data for Checks,
Clients, Events, Aggregates, Stashes, and more.

This reference document provides information to help you:

- [Configure the Sensu API](#anatomy-of-an-api-definition)

_NOTE: Please visit the [Sensu Enterprise API](enterprise-api) reference
documentation for information on configuring the Sensu Enterprise API (including
native SSL encryption)._

## Anatomy of an API definition

### Example API definition

The following is an example API definition at `/etc/sensu/conf.d/api.json`.

~~~ json
{
  "api": {
    "host": "57.43.53.22",
    "bind": "0.0.0.0",
    "port": 4567
  }
}
~~~

### Definition attributes

The API definition uses the `"api": {}` definition scope.

host
: description
  : The hostname or IP address that is used when querying the API. This attribute does not configure the address that the API binds to (that's `bind`). This attribute is used by Sensu tooling to know how to query the Sensu API.
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

bind
: description
  : The address that the API will bind to (listen on).
: required
  : false
: type
  : String
: default
  : `0.0.0.0`
: example
  : ~~~ shell
    "bind": "127.0.0.1"
    ~~~

port
: description
  : The API HTTP port.
: required
  : false
: type
  : Integer
: default
  : `4567`
: example
  : ~~~ shell
    "port": 4242
    ~~~
