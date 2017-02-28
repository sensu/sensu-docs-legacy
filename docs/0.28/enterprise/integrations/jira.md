---
title: "JIRA"
version: 0.28
weight: 2
---

**ENTERPRISE: Built-in integrations are available for [Sensu Enterprise][1]
users only.**

# JIRA Integration

- [Overview](#overview)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Integration specification](#integration-specification)
    - [`jira` attributes](#jira-attributes)

## Overview

Create and resolve [Jira][2] issues for [Sensu events][3].

## Configuration

### Example(s)

The following is an example global configuration for the `jira` enterprise
event handler (integration).

~~~ json
{
  "jira": {
    "host": "jira.example.com",
    "user": "admin",
    "password": "secret",
    "project": "Sensu",
    "timeout": 10
  }
}
~~~

### Integration Specification

#### `jira` attributes

The following attributes are configured within the `{"jira": {} }`
[configuration scope][4].

`host`
: description
  : The JIRA host address.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "host": "jira.example.com"
    ~~~

`user`
: description
  : The JIRA user used to authenticate.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "user": "admin"
    ~~~

`password`
: description
  : The JIRA user password.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "password": "secret"
    ~~~

`project`
: description
  : The JIRA project to use for issues.
: required
  : false
: type
  : String
: default
  : `Sensu`
: example
  : ~~~ shell
    "project": "Alerts"
    ~~~

`project_key`
: description
  : The JIRA project key to use for issues. This option allows the
  integration to work without querying JIRA for a projects key. Using
  this option is recommended.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "project_key": "SEN"
    ~~~

`root_url`
: description
  : The JIRA root URL. When set, this option overrides the `host`
  option, most commonly used when a service proxy is in use.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "root_url": "https://services.example.com/proxy/jira"
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
[2]:  https://www.atlassian.com/software/jira
[3]:  ../../reference/events.html
[4]:  ../../reference/configuration.html#configuration-scopes
