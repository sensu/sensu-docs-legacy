---
title: "HipChat"
description: "Send notification to a HipChat room for Sensu events."
version: 0.26
weight: 7
---

**ENTERPRISE: Built-in integrations are available for [Sensu Enterprise][1]
users only.**

# HipChat Integration

- [Overview](#overview)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Integration Specification](#integration-specification)
    - [`hipchat` attributes](#hipchat-attributes)

## Overview

Send notifications to a [HipChat][2] room for events. After [creating a HipChat
API token][3], configure the handler (integration) with the provided API token.

## Configuration

### Example(s)

The following is an example global configuration for the `hipchat` enterprise
event handler (integration).

~~~ json
{
  "hipchat": {
    "api_token": "L7kVQzXF7c5eUMYUon6INaSVRDU8mP",
    "api_version": "v2",
    "username": "sensu",
    "room": "Operations",
    "timeout": 10
  }
}
~~~

### Integration Specification

#### `hipchat` attributes

The following attributes are configured within the `{"hipchat": {} }`
[configuration scope][4].

`api_token`
: description
  : The HipChat API token - [https://www.hipchat.com/docs/api/auth][3].
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "api_token": "L7kVQzXF7c5eUMYUon6INaSVRDU8mP"
    ~~~

`server_url`
: description
  : The URL of the HipChat server (used for self-hosted HipChat installations)
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "server_url": "https://hipchat.example.com"
    ~~~

`api_version`
: description
  : The HipChat API version to use.
: required
  : false
: type
  : String
: default
  : `v2`
: example
  : ~~~ shell
    "api_version": "v2"
    ~~~

`username`
: description
  : The HipChat username to use to notify the room.
: required
  : false
: type
  : String
: default
  : `sensu`
: example
  : ~~~ shell
    "username": "monitoring"
    ~~~

`room`
: description
  : The HipChat room to notify.
: required
  : false
: type
  : String
: default
  : `sensu`
: example
  : ~~~ shell
    "room": "Search"
    ~~~

`notify`
: description
  : Configures whether notifications sent from Sensu Enterprise to HipChat
    should trigger a user notification (change the tab color, play a sound,
    notify mobile phones, etc). Each recipient's notification preferences are
    taken into account.
: required
  : false
: type
  : Boolean
: default
  : false
: example
  : ~~~ shell
    "notify": true
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
[2]:  https://www.hipchat.com?ref=sensu-enterprise
[3]:  https://www.hipchat.com/docs/api/auth?ref=sensu-enterprise
[4]:  ../../reference/configuration.html#configuration-scopes
