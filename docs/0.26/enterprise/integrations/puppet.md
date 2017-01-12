---
title: "Puppet"
description: "Deregister Sensu clients from the client registry if they no
  longer have an associated Puppet node."
version: 0.26
weight: 12
---

**ENTERPRISE: Built-in integrations are available for [Sensu Enterprise][1]
users only.**

# Puppet Integration

- [Overview](#overview)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Integration Specification](#integration-specification)
    - [`puppet` attributes](#puppet-attributes)
    - [`ssl` attributes](#ssl-attributes)

## Overview

Deregister Sensu clients from the client registry if they no longer have an
associated [Puppet][2] node. The `puppet` enterprise handler requires access to
a SSL truststore and keystore, containing a valid (and whitelisted) Puppet
certificate, private key, and CA. The local Puppet agent certificate, private
key, and CA can be used.

## Configuration

### Example(s)

The following is an example global configuration for the `puppet` enterprise
handler (integration).

~~~ json
{
  "puppet": {
    "endpoint": "https://10.0.1.12:8081/pdb/query/v4/nodes/",
    "ssl": {
      "keystore_file": "/etc/sensu/ssl/puppet/keystore.jks",
      "keystore_password": "secret",
      "truststore_file": "/etc/sensu/ssl/puppet/truststore.jks",
      "truststore_password": "secret"
    },
    "timeout": 10
  }
}
~~~

The Puppet enterprise handler is most commonly used as part of the `keepalive`
set handler. For example:

~~~ json
{
  "handlers": {
    "keepalive": {
      "type": "set",
      "handlers": [
        "pagerduty",
        "puppet"
      ]
    }
  }
}
~~~

When querying PuppetDB for a node, by default, Sensu will use the Sensu client's
name for the Puppet node name. Individual Sensu clients can override the name of
their corresponding Puppet node, using specific client definition attributes.

The following is an example client definition, specifying its Puppet node name.

~~~ json
{
  "client": {
    "name": "i-424242",
    "address": "8.8.8.8",
    "subscriptions": [
      "production",
      "webserver"
    ],
    "puppet": {
      "node_name": "webserver01.example.com"
    }
  }
}
~~~

### Integration Specification

_NOTE: the following integration definition attributes may be overwritten by
the corresponding Sensu [client definition `puppet` attributes][3], which are
included in [event data][4]._

#### `puppet` attributes

The following attributes are configured within the `{"puppet": {} }`
[configuration scope][5].

`endpoint`
: description
  : The PuppetDB API endpoint (URL). If an API path is not specified,
    `/pdb/query/v4/nodes/` will be used.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "endpoint": "https://10.0.1.12:8081/pdb/query/v4/nodes/"
    ~~~

`ssl`
: description
  : A set of attributes that configure SSL for PuppetDB API queries.
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "ssl": {}
    ~~~

#### `ssl` attributes

The following attributes are configured within the `{"puppet": { "ssl": {} } }`
[configuration scope][3].

##### EXAMPLE {#ssl-attributes-example}

~~~ json
{
  "puppet": {
    "endpoint": "https://10.0.1.12:8081/pdb/query/v4/nodes/",
    "...": "...",
    "ssl": {
      "keystore_file": "/etc/sensu/ssl/puppet/keystore.jks",
      "keystore_password": "secret",
      "truststore_file": "/etc/sensu/ssl/puppet/truststore.jks",
      "truststore_password": "secret"
    }
  }
}
~~~

##### ATTRIBUTES {#ssl-attributes-specification}

`keystore_file`
: description
  : The file path for the SSL certificate keystore.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "keystore_file": "/etc/sensu/ssl/puppet/keystore.jks"
    ~~~

`keystore_password`
: description
  : The SSL certificate keystore password.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "keystore_password": "secret"
    ~~~

`truststore_file`
: description
  : The file path for the SSL certificate truststore.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "truststore_file": "/etc/sensu/ssl/puppet/truststore.jks"
    ~~~

`truststore_password`
: description
  : The SSL certificate truststore password.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "truststore_password": "secret"
    ~~~


[?]:  #
[1]:  /enterprise
[2]:  https://puppet.com?ref=sensu-enterprise
[3]:  ../../reference/clients.html#puppet-attributes
[4]:  ../../reference/events.html#event-data
[5]:  ../../reference/configuration.html#configuration-scopes
