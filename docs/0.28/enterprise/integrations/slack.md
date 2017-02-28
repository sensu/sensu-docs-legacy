---
title: "Slack"
version: 0.28
weight: 6
---

**ENTERPRISE: Built-in integrations are available for [Sensu Enterprise][1]
users only.**

# Slack Integration

- [Overview](#overview)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Integration Specification](#integration-specification)
    - [`slack` attributes](#slack-attributes)

## Overview

Send notifications to a [Slack][2] channel for events. After [configuring an
incoming webhook in Slack][3], configure the handler (integration) with the
provided webhook url.

## Configuration

### Example(s)

The following is an example global configuration for the `slack` enterprise
event handler (integration).

~~~ json
{
  "slack": {
    "webhook_url": "https://hooks.slack.com/services/IB6JgRmRJ/eL7Hgo6kF/CckJm8E4Yt8X3i6QRKHWBekc",
    "username": "sensu",
    "channel": "#ops",
    "timeout": 10
  }
}
~~~

### Integration Specification

#### `slack` attributes

The following attributes are configured within the `{"slack": {} }`
[configuration scope][4].

`webhook_url`
: description
  : The Slack incoming webhook URL - [https://api.slack.com/incoming-webhooks][3].
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "webhook_url": "https://hooks.slack.com/services/IB6JgRmRJ/eL7Hgo6kF/CckJm8E4Yt8X3i6QRKHWBekc"
    ~~~

`channel`
: description
  : The Slack channel to notify.
: required
  : false
: type
  : String
: default
  : `#general`
: example
  : ~~~ shell
    "channel": "#ops"
    ~~~

`username`
: description
  : The Slack username to use to notify the channel.
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

`icon_url`
: description
  : The Slack icon URL to use for notifications.
: required
  : false
: type
  : String
: default
  : `http://www.gravatar.com/avatar/9b37917076cee4e2d331a785f3426640`
: example
  : ~~~ shell
    "icon_url": "http://www.gravatar.com/avatar/9b37917076cee4e2d331a785f3426640"
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
[2]:  https://slack.com?ref=sensu-enterprise
[3]:  https://api.slack.com/incoming-webhooks?ref=sensu-enterprise
[4]:  ../../reference/configuration.html#configuration-scopes
