---
version: 0.22
category: "Reference Docs"
title: "Events"
next:
  url: "filters"
  text: "Sensu Filters"
---

# Sensu Events

## Reference Documentation

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

A Sensu Event is created when a check result indicates a change in state.

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
{
  "action": "create",
  "occurrences": 1,
  "client": {
    "name": "i-424242",
    "address": "8.8.8.8",
    "subscriptions": [
      "production",
      "webserver",
      "mysql"
    ],
    "timestamp": 1326390159
  },
  "check":{
    "name": "frontend_http_check",
    "issued": 1326390169,
    "subscribers":[
      "frontend"
    ],
    "interval": 60,
    "command": "check_http -I 127.0.0.1 -u http://web.example.com/healthcheck.html -R 'pageok'",
    "output": "HTTP CRITICAL: HTTP/1.1 503 Service Temporarily Unavailable",
    "status": 2,
    "handler": "slack",
    "history": [
      "0",
      "2"
    ]
  }
}
~~~

### Event data specification

action
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

occurrences
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

client
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

check
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


[1]:  handlers
[2]:  #event-data
[3]:  checks
[4]:  checks#check-results
[5]:  #event-data-specification
