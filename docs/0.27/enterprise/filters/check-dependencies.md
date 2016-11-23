---
title: "check_dependencies"
description: "The check_dependencies Enterprise filter is used to filter events
  when an event already exists for a defined check dependency."
version: 0.27
weight: 1
---

**ENTERPRISE: Built-in filters are available for [Sensu Enterprise][0]
users only.**

# The `check_dependencies` filter

## Reference documentation

- [Overview](#overview)
- [Configuration](#configuration)
  - [Example(s)](#examples)
  - [Filter specification](#filter-specification)
    - [`CHECK` attributes](#check-attributes)

## Overview

The `check_dependencies` enterprise filter is used to filter events when an
event already exists for a defined check dependency, enabling the user to reduce
notification noise and only be notified for the "root cause" of a given failure.
Check dependencies can be defined in the check definition, using `dependencies`,
an array of checks (e.g. `check_app`) or Sensu client/check pairs (e.g.
`db-01/check_mysql`).

## Configuration

### Example(s)

The following is an example of how to configure a check dependency for a check.
The example check monitors a web application API and has a dependency on another
check that monitors the local MySQL database.

~~~ json
{
  "checks": {
    "web_application_api": {
      "command": "check-http.rb -u https://localhost:8080/api/v1/health",
      "subscribers": [
        "web_application"
      ],
      "interval": 20,
      "dependencies": [
        "mysql"
      ]
    }
  }
}
~~~

The `web_application_api` check could depend on a check executed by another
Sensu client, in this example a Sensu client named `db-01`.

~~~ json
{
  "checks": {
    "web_application_api": {
      "command": "check-http.rb -u https://localhost:8080/api/v1/health",
      "subscribers": [
        "web_application"
      ],
      "interval": 20,
      "dependencies": [
        "db-01/mysql"
      ]
    }
  }
}
~~~

The following is an example of how to apply the `check_dependencies` enterprise
filter to a standard Sensu `pipe` handler.

~~~ json
{
  "handlers": {
    "custom_mailer": {
      "type": "pipe",
      "command": "custom_mailer.rb",
      "filter": "check_dependencies"
    }
  }
}
~~~

### Filter specification

#### `CHECK` attributes

The following attributes are configured within the `{"checks": { "CHECK": {} }
}` [configuration scope][1].

`dependencies`
: description
  : An array of check dependencies. Events for the check will not be handled if
    events exist for one or more of the check dependencies. A check dependency
    can be a check executed by the same Sensu client (eg. `check_app`), or a
    client/check pair (eg.`db-01/check_mysql`).
: required
  : false
: type
  : Array
: example
  : ~~~ shell
    "dependencies": [
      "check_app",
      "db-01/check_mysql"
    ]
    ~~~


[?]:  #
[0]:  /enterprise
[1]:  ../reference/configuration.html#configuration-scopes
