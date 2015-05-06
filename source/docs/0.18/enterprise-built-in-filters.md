---
version: 0.17
category: "Enterprise Docs"
title: "Built-in Filters"
next:
  url: "enterprise-built-in-mutators"
  text: "Enterprise Built-in Mutators"
---

# Overview

Sensu Enterprise has several built-in event filters, used by many of the third-party integrations, and made available to standard Sensu event handlers. These enterprise filters can be used to combat alert fatigue.

# Enterprise filters

## handle_when

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

### Definition attributes

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

#### Handle when attributes

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

## silence_stashes

The `silence_stashes` enterprise filter is used to filter events when specific [Sensu API stashes](api-stashes) exist. The Sensu Enterprise Dashboard and many community tools make use of "silence stashes" to indicate Sensu clients and/or their checks that are "silenced" or under maintenance. Events will be filtered if a silence stash exists for the client and/or its check specified in the event data.

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
