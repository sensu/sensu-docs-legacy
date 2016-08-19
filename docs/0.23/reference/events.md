---
title: "Events"
version: 0.23
weight: 5
---

# Sensu Events

## Reference documentation

- [What are Sensu events?](#what-are-sensu-events)
  - [How are Sensu events created?](#how-are-sensu-events-created)
  - [Event actions](#event-actions)
- [Event data](#event-data)
  - [Example event](#example-event)
  - [Event data specification](#event-data-specification)

## What are Sensu events? {#what-are-sensu-events}

Sensu events are created to acknowledge that something potentially noteworthy
has occurred, which events may then be processed by one or more [event
handlers][1] to do things such as send an email, or invoke an automated action.
Every Sensu event provides context, called ["event data"][2], which contains
information about the originating [Sensu client][3] and the corresponding [check
result][4].

### How are Sensu events created?

A Sensu Event is created every time a [check result][8] is processed by the
Sensu server, regardless of the status indicated by the check result. An Event
is created by collating data from the check result, the [client registry][9] and
additional context added at the time of processing.

### Event actions

Sensu supports the following event actions.

- **create**. Indicates a check result `status` change from zero to non-zero.
- **resolve**. Indicates a check result `status` change from a non-zero to zero.
- **flapping**. Indicates a rapid change in check result `status`.

_NOTE: for more information on event `action`s, please see the [Sensu event data
specification][5], below._

## Event data

### Example event

The following is an example Sensu event. By default, event data is JSON
formatted, making it language-independent and fairly human readable.

~~~ json
[
  {
    "id": "ef6b87d2-1f89-439f-8bea-33881436ab90",
    "action": "create",
    "timestamp": 1460172826,
    "occurrences": 2,
    "check": {
      "total_state_change": 11,
      "history": ["0", "0", "1", "1", "2", "2"],
      "status": 2,
      "output": "No keepalive sent from client for 230 seconds (>=180)",
      "executed": 1460172826,
      "issued": 1460172826,
      "name": "keepalive",
      "thresholds": {
        "critical": 180,
        "warning": 120
      }
    },
    "client": {
      "timestamp": 1460172596,
      "version": "0.23.0",
      "socket": {
        "port": 3030,
        "bind": "127.0.0.1"
      },
      "subscriptions": [
        "production"
      ],
      "environment": "development",
      "address": "127.0.0.1",
      "name": "client-01"
    }
  }
]
~~~

### Event data specification

`timestamp`
: description
  : The time the event occurred in [Epoch time][6] (generated via Ruby
    `Time.now.to_i`)
: type
  : Integer
: example
  : ~~~ shell
    "timestamp": 1460172826
    ~~~

`action`
: description
  : The Sensu event action, providing event handlers with more information about the state change.
: type
  : String
: possible values
  : `create`, `resolve`, `flapping`
: default
  : `create`
: example
  : ~~~ shell
    "action": "create"
    ~~~

`occurrences`
: description
  : The occurrence count for the event; the number of times an event has been created for a client/check pair with the same state (check status).
: type
  : Integer
: default
  : `1`
: example
  : ~~~ shell
    "occurrences": 3
    ~~~

`check`
: description
  : The corresponding check result data including the check history.
: type
  : Hash
: example
  : ~~~ shell
    "check":{
      "name": "chef_client",
      "command": "/etc/sensu/plugins/check-chef-client.rb",
      "subscribers": [
        "production"
      ],
      "interval": 60,
      "handler": "slack",
      "issued": 1326390169,
      "output": "WARNING - Chef client process is NOT running",
      "status": 1,
      "history": [
        "0",
        "1"
      ]
    }
    ~~~

`client`
: description
  : Originating Sensu client data.
: type
  : Hash
: example
  : ~~~ shell
    "client": {
      "name": "i-424242",
      "address": "8.8.8.8",
      "subscriptions": [
        "production",
        "webserver",
        "mysql"
      ],
      "timestamp": 1326390159
    }
    ~~~

`id`
: description
  : Unique id for the event occurrence
: type
  : String
: possible values
  : Any [Ruby `SecureRandom.uuid` value][7]
: example
  : ~~~ shell
    "id": "66926524-da77-41a4-92bd-365498841079"
    ~~~

[1]:  handlers.html
[2]:  #event-data
[3]:  checks.html
[4]:  checks.html#check-results
[5]:  #event-data-specification
[6]:  https://en.wikipedia.org/wiki/Unix_time
[7]:  http://ruby-doc.org/stdlib-2.3.0/libdoc/securerandom/rdoc/SecureRandom.html
[8]:  checks.html#check-results
[9]:  clients.html#registration-and-registry