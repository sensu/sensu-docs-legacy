---
version: "0.16"
category: "Enterprise"
title: "Enterprise filters"
---

# Enterprise filters

## handle_when

The `handle_when` enterprise filter is used to reduce notification
"noise". Users can define a minimum number of event `occurrences`
before notifications will be sent. Users can also specify a `reset`
time, in seconds, to reset where recurrences are counted from, to
control when reminder/update notifications are sent. By default,
`occurrences` is set to `1`, and reset is `1800` (30 minutes). The
`handle_when` filter is used by all of the [enterprise third-party
integrations](enterprise_integrations).

The following is an example of how to configure a check to only notify
after 2 occurrences and send reminder/update notifications every 20
minutes.

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

The following is an example of how to use the `handle_when` enterprise
filter with a standard Sensu `pipe` handler.

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
