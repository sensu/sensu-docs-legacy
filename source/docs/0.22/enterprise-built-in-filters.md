---
version: 0.22
category: "Enterprise Docs"
title: "Built-in Filters"
next:
  url: "enterprise-built-in-mutators"
  text: "Enterprise Built-in Mutators"
---

# Built-in Filters in Sensu Enterprise

Sensu Enterprise has several built-in event filters, used by many of the third-party integrations, and made available to standard Sensu event handlers. These enterprise filters can be used to combat alert fatigue.

## Enterprise filters

### The handle_when filter

The `handle_when` enterprise filter is used to reduce notification "noise". Users can define a minimum number of event `occurrences` before notifications will be sent. Users can also specify a `reset` time, in seconds, to reset where recurrences are counted from, to control when reminder/update notifications are sent. By default, `occurrences` is set to `1`, and reset is `1800` (30 minutes). The `handle_when` filter is used by all of the [enterprise third-party integrations](enterprise_integrations).

The following is an example of how to configure a check to only notify after 2 occurrences and send reminder/update notifications every 20 minutes. Sensu Enterprise integrations and standard event handlers using the `handle_when` enterprise filter will have events filtered unless these conditions are met.

~~~ json
{
  "checks": {
    "load_balancer_listeners": {
      "command": "check-haproxy.rb -s /var/run/haproxy.sock -A",
      "subscribers": [
        "load_balancer"
      ],
      "interval": 20,
      "handle_when": {
        "occurrences": 2,
        "reset": 1200
      }
    }
  }
}
~~~

The following is an example of how to apply the `handle_when` enterprise filter to a standard Sensu `pipe` handler.

~~~ json
{
  "handlers": {
    "custom_mailer": {
      "type": "pipe",
      "command": "custom_mailer.rb",
      "filter": "handle_when"
    }
  }
}
~~~

#### Definition attributes

handle_when
: description
  : A set of attributes that determine when events should be handled for a check.
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "handle_when": {}
    ~~~

##### handle_when attributes

occurrences
: description
  : The number of occurrences that must occur before an event is handled for a check.
: required
  : false
: type
  : Integer
: default
  : `1`
: example
  : ~~~ shell
    "occurrences": 3
    ~~~

reset
: description
  : Time in seconds until the occurrence count is considered "reset", to allow the event to be handled once again.
: required
  : false
: type
  : Integer
: default
  : `1800`
: example
  : ~~~ shell
    "reset": 3600
    ~~~

### The silence_stashes filter

The `silence_stashes` Enterprise filter is used to filter events when specific [Sensu API stashes](api-stashes) exist. The Sensu Enterprise Dashboard and many community tools make use of "silence stashes" to indicate Sensu clients and/or their checks that are "silenced" or under maintenance. Events will be filtered if a silence stash exists for the client and/or its check specified in the event data.

#### Example silence_stashes filter configuration

The following is an example of how to apply the `silence_stashes` enterprise filter to a standard Sensu `pipe` handler.

~~~ json
{
  "handlers": {
    "custom_mailer": {
      "type": "pipe",
      "command": "custom_mailer.rb",
      "filter": "silence_stashes"
    }
  }
}
~~~

### The check_dependencies filter

The `check_dependencies` enterprise filter is used to filter events when an event already exists for a defined check dependency, enabling the user to reduce notification noise and only be notified for the "root cause" of a given failure. Check dependencies can be defined in the check definition, using `dependencies`, an array of checks (e.g. `check_app`) or Sensu client/check pairs (e.g. `db-01/check_mysql`).

#### Example check_dependencies filter configurations

The following is an example of how to configure a check dependency for a check. The example check monitors a web application API and has a dependency on another check that monitors the local MySQL database.

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

The `web_application_api` check could depend on a check executed by another Sensu client, in this example a Sensu client named `db-01`.

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

The following is an example of how to apply the `check_dependencies` enterprise filter to a standard Sensu `pipe` handler.

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

#### Definition attributes

dependencies
: description
  : An array of check dependencies. Events for the check will not be handled if events exist for one or more of the check dependencies. A check dependency can be a check executed by the same Sensu client (eg. `check_app`), or a client/check pair (eg.`db-01/check_mysql`).
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

### Using multiple Enterprise filters

Multiple enterprise filters can be applied to standard Sensu event handlers. The following example event handler uses the `handle_when` and `silence_stashes` event filters.

~~~ json
{
  "handlers": {
    "custom_mailer": {
      "type": "pipe",
      "command": "custom_mailer.rb",
      "filters": [
        "handle_when",
        "silence_stashes"
      ]
    }
  }
}
~~~
