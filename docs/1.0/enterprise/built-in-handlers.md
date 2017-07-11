---
title: "Built-in Handlers"
version: 1.0
weight: 6
next:
  url: "built-in-filters.html"
  text: "Enterprise Built-in Filters"
---

**ENTERPRISE: Built-in handlers are available for [Sensu Enterprise][0]
users only.**

# Built-in Handlers

## Reference documentation

- [What are built-in handlers?](#what-are-built-in-handlers)
- [How to use built-in handlers?](#how-to-use-built-in-handlers)
  - [Examples](#example-integration-configurations)
- [List of built-in handlers](#list-of-built-in-handlers)

## What are built-in Handlers?

Sensu Enterprise ships with several built-in third-party integrations, which
provide Sensu [event handlers][1]. These built-in handlers can be used to handle
events for any [check][2]. The Enterprise integrations use their own global
configuration namespaces in combination with [enterprise contact routing][3] to
provide granular controls over how events should be handled in a variety of
circumstances.

## How to use built-in handlers

After configuring one or more [enterprise handlers][4], you can specify which
ones are used per check or create a default handler set to specify those used by
default.

### Examples {#example-integration-configurations}

The following is an example of how to configure a Sensu check to use the
built-in `email` integration (i.e. Enterprise handler).

`/etc/sensu/conf.d/checks/load_balancer_listeners.json`

~~~ json
{
  "checks": {
    "load_balancer_listeners": {
      "command": "check-haproxy.rb -s /var/run/haproxy.sock -A",
      "subscribers": [
        "load_balancer"
      ],
      "interval": 20,
      "handler": "email"
    }
  }
}
~~~

The following is an example of how to configure the Sensu default handler in
order to specify one or more built-in enterprise handlers. The default handler
is used when a check definition does not specify one or more event handlers.
This example specifies the built-in `email` and `slack` enterprise handlers.

`/etc/sensu/conf.d/handlers/default.json`

~~~ json
{
  "handlers": {
    "default": {
      "type": "set",
      "handlers": [
        "email",
        "slack"
      ]
    }
  }
}
~~~


## List of built-in handlers

Built-in event handlers:

- [Email](integrations/email.html) - send email notifications for events
- [PagerDuty](integrations/pagerduty.html) - create and resolve PagerDuty incidents for events
- [ServiceNow](integrations/servicenow.html) - create ServiceNow CMDB configuration items and incidents
- [JIRA](integrations/jira.html) - create and resolve JIRA issues for Sensu events
- [VictorOps](integrations/victorops.html) - create and resolve VictorOps messages for events
- [OpsGenie](integrations/opsgenie.html) - create and close OpsGenie alerts for events
- [Slack](integrations/slack.html) - send notifications to a Slack channel for events
- [HipChat](integrations/hipchat.html) - send notifications to a HipChat room for events
- [IRC](integrations/irc.html) - send notifications to an IRC channel for events
- [SNMP](integrations/snmp.html) - send SNMP traps to a SNMP manager
- [Graylog](integrations/graylog.html) - send Sensu events to Graylog
- [Flapjack](integrations/flapjack.html) - relay Sensu check results to Flapjack
- [Puppet](integrations/puppet.html) - deregister Sensu clients without an associated Puppet node
- [Chef](integrations/chef.html) - deregister Sensu clients without an associated Chef node
- [EC2](integrations/ec2.html) - deregister Sensu clients without an allowed EC2 instance state
- [Event Stream](integrations/event_stream.html) - send all Sensu events to a remote TCP socket
- [InfluxDB](integrations/influxdb.html) - send metrics to InfluxDB
- [Graphite](integrations/graphite.html) - send metrics to Graphite
- [Wavefront](integrations/wavefront.html) - send metrics to Wavefront
- [Librato](integrations/librato.html) - send metrics to Librato Metrics
- [OpenTSDB](integrations/opentsdb.html) - send metrics to OpenTSDB
- [DataDog](integrations/datadog.html) - create Datadog events

[?]:  #
[0]:  /enterprise
[1]:  ../reference/handles.html
[2]:  ../reference/checks.html
[3]:  contact-routing.html
[4]:  #list-of-built-in-handlers
