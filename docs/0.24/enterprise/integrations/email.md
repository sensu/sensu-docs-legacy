---
title: "Email"
description: "User documentation for the built-in email integration in Sensu
  Enterprise. Send email notifications for events via SMTP."
version: 0.24
weight: 1
---

**ENTERPRISE: Built-in integrations are available for [Sensu Enterprise][1]
users only.**

# Email Integration

- [Overview](#overview)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Integration Specification](#integration-specification)
    - [`email` attributes](#email-attributes)
    - [`smtp` attributes](#smtp-attributes)

## Overview

Send email notifications for events, using SMTP.

## Configuration

### Example(s)

The following is an example configuration for the `email` enterprise event
handler (integration).

~~~ json
{
  "email": {
    "smtp": {
      "address": "smtp.example.com",
      "port": 587,
      "openssl_verify_mode": "none",
      "enable_starttls_auto": true,
      "authentication": "plain",
      "user_name": "postmaster@example.com",
      "password": "SECRET"
    },
    "to": "support@example.com",
    "from": "noreply@example.com",
    "timeout": 10
  }
}
~~~

### Integration specification

#### `email` attributes

The following attributes are configured within the `{"email": {} }`
[configuration scope][2].

`smtp`
: description
  : A set of attributes that provides SMTP connection information to the email event handler.
: required
  : false
: type
  : Hash
: default
  : ~~~ shell
    "smtp": {
      "address": "127.0.0.1",
      "port": 25,
      "domain": "localhost.localdomain",
      "openssl_verify_mode": "none",
      "enable_starttls_auto": true,
      "user_name": null,
      "password": null,
      "authentication": "plain"
    }
    ~~~
: example
  : ~~~ shell
    "smtp": {
      "address": "smtp.example.com",
      "port": 587
    }
    ~~~

`to`
: description
  : The default email address to send notification to.
: required
  : false
: type
  : String
: default
  : `root@localhost`
: example
  : ~~~ shell
    "to": "support@example.com"
    ~~~

`from`
: description
  : The default email address to use as the sender.
: required
  : false
: type
  : String
: default
  : `sensu@localhost`
: example
  : ~~~ shell
    "from": "noreply@example.com"
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

#### `smtp` attributes

The following attributes are configured within the `{"email": { "smtp": {} } }`
[configuration scope][2].

##### EXAMPLE {#smtp-attributes-example}

~~~ json
{
  "email": {
    "smtp": {
      "address": "smtp.example.com",
      "port": 587,
      "...": "..."
    },
    "to": "support@example.com",
    "from": "noreply@example.com",
    "timeout": 10
  }
}
~~~

##### ATTRIBUTES {#smtp-attributes-specification}

`address`
: description
  : The hostname or IP address of the SMTP server
: type
  : String
: required
  : true
: default
  : "127.0.0.1"
: example
  : ~~~ shell
    "address": "smtp.example.com"
    ~~~

`port`
: description
  : The SMTP sever port
: type
  : Integer
: required
  : true
: default
  : `25`
: example
  : ~~~ shell
    "port": 25
    ~~~

`domain`
: description
  : The domain the SMTP server should use to send email from.
: type
  : String
: required
  : true
: default
  : `localhost.localdomain`
: example
  : ~~~ shell
    "domain": "localhost.localdomain"
    ~~~

`openssl_verify_mode`
: description
  : What SSL verification mode Sensu should use to establish a connection with
    the SMTP server.
: type
  : String
: required
  : true
: default
  : `"none"`
: example
  : ~~~ shell
    "openssl_verify_mode": "none"
    ~~~

`enable_starttls_auto`
: description
  : Whether Sensu should use `STARTTLS` (or "Opportunistic TLS") to upgrade
    insecure connections with TLS encryption, when possible.
: type
  : Boolean
: required
  : true
: default
  : `true`
: example
  : ~~~ shell
    "enable_starttls_auto": true
    ~~~

`user_name`
: description
  : The username credential Sensu should use to authenticate to the SMTP server.
: type
  : String
: required
  : false
: default
  : `null`
: example
  : ~~~ shell
    "username": "monitoring@example.com"
    ~~~

`password`
: description
  : The password credential Sensu should use to authenticate to the SMTP server.
: type
  : String
: required
  : false
: default
  : `null`
: example
  : ~~~ shell
    "passsword": "PASSWORD"
    ~~~

`authentication`
: description
  : The authentication method should Sensu use when connecting to the SMTP
    server.
: type
  : String
: required
  : true
: default
  : `"plain"`
: example
  : ~~~ shell
    "authentication": "plain"
    ~~~


[?]:  #
[1]:  /enterprise
[2]:  ../../reference/configuration.html#configuration-scopes
