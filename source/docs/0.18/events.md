---
version: 0.17
category: "Reference Docs"
title: "Events"
next:
  url: "rabbitmq"
  text: "RabbitMQ Configuration"
---

# Overview

This reference document provides information to help you:

- Understand what a Sensu event is
- How and when Sensu events are created
- What is included in event data

# What are Sensu events? {#what-are-sensu-events}

A Sensu Event is created when a check result indicates a change in state. Sensu events are created to acknowledge that something potentially noteworthy has occurred, which may then be associated with one or more event handlers to do things such as send an email, or invoke an automated action. Every Sensu event provides context, called "event data", which contains information about the originating Sensu client and the corresponding check result. When a check result indicates a change in state from a zero to a non-zero status, this generates a Sensu event with a "create" `action`; when a check result indicates a change in state from a non-zero to a zero status, this generates a Sensu event with a "resolve" `action` (see reference documentation for `action`, below).

# Sensu event data {#sensu-event-data}

The following is an example Sensu event. By default, event data is JSON formatted, making it language-independent and fairly human readable.

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

# Anatomy of event data

### Event data attributes

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
