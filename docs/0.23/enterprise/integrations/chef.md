---
title: "Chef"
description: "Deregister Sensu clients from the client registry, if they no
  longer have associated Chef node data."
version: 0.23
weight: 12
---

**ENTERPRISE: Built-in integrations are available for [Sensu Enterprise][1]
users only.**

# Chef Integration

- [Overview](#overview)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Integration Specification](#integration-specification)
    - [`chef` attributes](#chef-attributes)

## Overview

Deregister Sensu clients from the client registry, if they no longer have
associated [Chef][2] [node data][3]. This integration can only work if Sensu
clients are named using the Chef node name, for the machine on which they
reside. The `chef` enterprise handler requires Chef Server API credentials, the
local chef-client configuration can be used as a reference.

## Configuration

### Example(s)

The following is an example global configuration for the `chef` enterprise
handler (integration).

~~~ json
{
  "chef": {
    "endpoint": "https://api.chef.io/organizations/example",
    "flavor": "enterprise",
    "client": "i-424242",
    "key": "/etc/chef/i-424242.pem",
    "ssl_pem_file": "/etc/chef/ssl.pem",
    "ssl_verify": true,
    "proxy_address": "proxy.example.com",
    "proxy_port": 8080,
    "proxy_username": "chef",
    "proxy_password": "secret",
    "timeout": 10
  }
}
~~~

### Integration Specification

_NOTE: the following integration definition attributes may be overwritten by
the corresponding Sensu [client definition `chef` attributes][4], which are
included in [event data][5]._

#### `chef` attributes

The following attributes are configured within the `{"chef": {} }`
[configuration scope][6].

`endpoint`
: description
  : The Chef Server API endpoint (URL).
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "endpoint": "https://api.chef.io/organizations/example"
    ~~~

`flavor`
: description
  : The Chef Server flavor (is it enterprise?).
: required
  : false
: type
  : String
: allowed values
  : `enterprise` (for Hosted Chef and Enterprise Chef) and `open_source` (for
    Chef Zero and Open Source Chef Server)
: example
  : ~~~ shell
    "flavor": "enterprise"
    ~~~

`client`
: description
  : The Chef Client name to use when authenticating/querying the Chef Server API.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "client": "sensu-server"
    ~~~

`key`
: description
  : The Chef Client key to use when authenticating/querying the Chef Server API.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "key": "/etc/chef/i-424242.pem"
    ~~~

`ssl_pem_file`
: description
  : The Chef SSL pem file use when querying the Chef Server API.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "ssl_pem_file": "/etc/chef/ssl.pem"
    ~~~

`ssl_verify`
: description
  : If the SSL certificate will be verified when querying the Chef Server API.
: required
  : false
: type
  : Boolean
: default
  : `true`
: example
  : ~~~ shell
    "ssl_verify": false
    ~~~

`proxy_address`
: description
  : The HTTP proxy address.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "proxy_address": "proxy.example.com"
    ~~~

`proxy_port`
: description
  : The HTTP proxy port (if there is a proxy).
: required
  : false
: type
  : Integer
: example
  : ~~~ shell
    "proxy_port": 8080
    ~~~

`proxy_username`
: description
  : The HTTP proxy username (if there is a proxy).
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "proxy_username": "chef"
    ~~~

`proxy_password`
: description
  : The HTTP proxy user password (if there is a proxy).
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "proxy_password": "secret"
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
[2]:  https://www.chef.io?ref=sensu-enterprise
[3]:  https://docs.chef.io/nodes.html
[4]:  ../../reference/clients.html#chef-attributes
[5]:  ../../reference/events.html#event-data
[6]:  ../../reference/configuration.html#configuration-scopes
