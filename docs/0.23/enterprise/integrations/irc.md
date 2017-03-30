---
title: "IRC"
version: 0.23
weight: 8
---

**ENTERPRISE: Built-in integrations are available for [Sensu Enterprise][1]
users only.**

# IRC Integration

- [Overview](#overview)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Integration Specification](#integration-specification)
    - [`irc` attributes](#irc-attributes)

## Overview

Send notifications to an Internet Relay Chat (IRC) channel for events.

## Configuration

### Example(s)

The following is an example global configuration for the `irc` enterprise event
handler (integration).

~~~ json
{
  "irc": {
    "uri": "irc://nick:pass@example.com:6697/#ops",
    "ssl": true,
    "nickserv_password": "NICKSERV_PASSWORD",
    "channel_password": "CHANNEL_PASSWORD",
    "join": false,
    "timeout": 10
  }
}
~~~

### Integration Specification

#### `irc` attributes

The following attributes are configured within the `{"irc": {} }` [configuration
scope][2].

`uri`
: description
  : The IRC URI; including the nick, password, address, port, and channel.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "uri": "irc://nick:pass@example.com:6697/#ops"
    ~~~

`ssl`
: description
  : If SSL encryption is used for the IRC connection.
: required
  : false
: type
  : Boolean
: default
  : `false`
: example
  : ~~~ shell
    "ssl": true
    ~~~

`channel_password`
: description
  : The IRC channel password (if required).
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "channel_password": "secret"
    ~~~

`nickserv_password`
: description
  : Identify with NickServ (if required).
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "nickserv_password": "secret"
    ~~~

`join`
: description
  : If the handler must join the IRC channel before messaging.
: required
  : false
: type
  : Boolean
: default
  : `false`
: example
  : ~~~ shell
    "join": true
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
[2]:  ../../reference/configuration.html#configuration-scopes
