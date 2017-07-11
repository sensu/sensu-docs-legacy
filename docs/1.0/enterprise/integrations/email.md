---
title: "Email"
description: "User documentation for the built-in email integration in Sensu
  Enterprise. Send email notifications for events via SMTP."
version: 1.0
weight: 1
---

**ENTERPRISE: Built-in integrations are available for [Sensu Enterprise][1]
users only.**

# Email Integration

- [Overview](#overview)
- [Custom email templates](#custom-email-templates)
  - [Example(s)](#custom-email-templates-example)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Integration Specification](#integration-specification)
    - [`email` attributes](#email-attributes)
    - [`smtp` attributes](#smtp-attributes)
    - [`templates` attributes](#templates-attributes)

## Overview

Send email notifications for events, using SMTP.

## Custom email templates

As of Sensu Enterprise version 2.3, the Sensu Enterprise email integration
provides support for creating custom email templates using ERB (a templating
language based on Ruby). Sensu Enterprise make an `@event` variable available to
the ERB template containing the complete [event data payload][4].

_NOTE: the Puppet reference documentation provides a helpful [introduction to
ERB templating syntax][5]._

### Example(s) {#custom-email-templates-example}

The following example demonstrates how to access the Sensu `@event` variable from
a custom ERB template.

~~~erb
Hi there,

Sensu has detected a <%= @event[:check][:name] %> monitoring event.
Please note the following details:

Client: <%= @event[:client][:name] %>

Check: <%= @event[:check][:name] %>

Output: <%= @event[:check][:output] %>

For more information, please consult the Sensu Enterprise dashboard:

https://sensu.example.com/#/client/<%= @event[:client][:datacenter] %>/<%= @event[:client][:name] %>?check=<%= @event[:check][:name] %>

#monitoringlove,
Team Sensu
~~~

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

`templates`
: description
  : A set of attributes that provides email [`templates` configuration][3].
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "templates": {
      "subject": "/etc/sensu/email/subject_template.erb",
      "body": "/etc/sensu/email/body_template.erb"
    }
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
  : false
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
  : false
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
  : false
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
  : false
: default
  : `none`
: example
  : ~~~ shell
    "openssl_verify_mode": "none"
    ~~~

`enable_starttls_auto`
: description
  : Whether Sensu should use `STARTTLS` (or "Opportunistic TLS") to upgrade
    insecure connections with TLS encryption, when possible. Sensu
    Enterprise uses TLSv1.2, ONLY supporting TLSv1.0+.
: type
  : Boolean
: required
  : false
: default
  : `true`
: example
  : ~~~ shell
    "enable_starttls_auto": true
    ~~~

`tls`
: description
  : Whether Sensu should use TLS encryption for connections. Sensu
  Enterprise uses TLSv1.2, ONLY supporting TLSv1.0+.
: type
  : Boolean
: required
  : false
: default
  : `false`
: example
  : ~~~ shell
    "tls": true
    ~~~

`user_name`
: description
  : The username credential Sensu should use to authenticate to the SMTP server.
: type
  : String
: required
  : false
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
  : false
: default
  : `plain`
: example
  : ~~~ shell
    "authentication": "plain"
    ~~~

#### `templates` attributes

The following attributes are configured within the `{"email": { "templates": {}
} }` [configuration scope][2].

`subject`
: description
  : Path to the email subject [ERB][5] template file, which must be accessible
    by the `sensu` system user. If an email subject template is not provided, a
    built-in default template will be used.
: type
  : String
: required
  : false
: example
  : ~~~ shell
    "subject": "/etc/sensu/email/subject_template.erb"
    ~~~

`body`
: description
  : Path to the email body [ERB][5] template file, which must be accessible
    by the `sensu` system user. If an email body template is not provided, a
    built-in default template will be used.
: type
  : String
: required
  : false
: example
  : ~~~ shell
    "body": "/etc/sensu/email/body_template.erb"
    ~~~



[?]:  #
[1]:  /enterprise
[2]:  ../../reference/configuration.html#configuration-scopes
[3]:  #templates-attributes
[4]:  ../../reference/events.html#event-data
[5]:  https://docs.puppet.com/puppet/latest/lang_template_erb.html
