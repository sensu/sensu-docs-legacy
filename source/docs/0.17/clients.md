---
version: 0.17
category: "Reference Docs"
title: "Clients"
next:
  url: "checks"
  text: "checks"
---

# Overview

This reference document provides information to help you:

- Understand what a Sensu client is
- What a Sensu client does
- Write a Sensu client definition
- Manage the Sensu client process

# Anatomy of a client definition

### Definition attributes

name
: description
  : A unique name for the client. The name cannot contain special characters or spaces.
: required
  : true
: type
  : String
: validation
  : `/^[\w\.-]+$/`
: example
  : ~~~ shell
    "name": "i-424242"
    ~~~

address
: description
  : An address to help identify and reach the client. This is only informational, usually an IP address or hostname.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "address": "8.8.8.8"
    ~~~

subscriptions
: description
  : An array of client subscriptions that check requests will be sent to. The array cannot be empty and its items must each be a string.
: required
  : true
: type
  : Array
: example
  : ~~~ shell
    "subscriptions": ["production", "webserver"]
    ~~~

safe_mode
: description
  : If safe mode is enabled for the client. Safe mode requires local check definitions in order to accept a check request and execute the check.
: required
  : false
: type
  : Boolean
: default
  : `false`
: example
  : ~~~ shell
    "safe_mode": true
    ~~~

redact
: description
  : Client definition attributes to redact (values) when logging and sending client keepalives.
: required
  : false
: type
  : Array
: default
  : ~~~ shell
    [
      "password", "passwd", "pass",
      "api_key", "api_token", "access_key",
      "secret_key", "private_key",
      "secret"
    ]
    ~~~
: example
  : ~~~ shell
    "redact": ["password", "ec2_access_key", "ec2_secret_key"]
    ~~~

socket
: description
  : A set of attributes that configure the Sensu client socket.
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "socket": {}
    ~~~

keepalive
: description
  : A set of attributes that configure the Sensu client keepalives.
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "keepalive": {}
    ~~~

### Socket attributes

bind
: description
  : The address to bind the Sensu client socket to.
: required
  : false
: type
  : String
: default
  : `127.0.0.1`
: example
  : ~~~ shell
    "bind": "0.0.0.0"
    ~~~

port
: description
  : The port the Sensu client socket listens on.
: required
  : false
: type
  : Integer
: default
  : `3030`
: example
  : ~~~ shell
    "port": 3031
    ~~~

### Keepalive attributes

handler
: description
  : The Sensu event handler (name) to use for events created by keepalives.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "handler": "pagerduty"
    ~~~

handlers
: description
  : An array of Sensu event handlers (names) to use for events created by keepalives. Each array item must be a string.
: required
  : false
: type
  : Array
: example
  : ~~~ shell
    "handlers": ["pagerduty", "chef"]
    ~~~

thresholds
: description
  : A set of attributes that configure the client keepalive "staleness" thresholds, when a client is determined to be unhealthy.
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "thresholds": {}
    ~~~

#### Keepalive thresholds attributes

warning
: description
  : The warning threshold (in seconds) where a Sensu client is determined to be unhealthy, not having sent a keepalive in so many seconds.
: required
  : false
: type
  : Integer
: default
  : `120`
: example
  : ~~~ shell
    "warning": 60
    ~~~

critical
: description
  : The critical threshold (in seconds) where a Sensu client is determined to be unhealthy, not having sent a keepalive in so many seconds.
: required
  : false
: type
  : Integer
: default
  : `180`
: example
  : ~~~ shell
    "critical": 90
    ~~~
