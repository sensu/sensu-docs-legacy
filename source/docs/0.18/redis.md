---
version: 0.18
category: "Reference Docs"
title: "Redis Configuration"
next:
  url: "ssl"
  text: "SSL Configuration"
---

# Overview

This reference document provides information to help you:

- Understand what Redis is
- Understand how Sensu uses Redis
- How to configure the Sensu Redis connection
- How to configure Redis
- How to secure Redis in production

# What is Redis?

Redis is a key-value database, which describes itself as “an open source, BSD licensed, advanced key-value cache and store”.

You can visit the official Redis website to learn more: [redis.io](http://redis.io/)

# How Sensu uses Redis

Sensu uses Redis for storing persistent data. When running Sensu Core, the Sensu server and API services (`sensu-server` and `sensu-api`) require access to Redis. When running Sensu Enterprise, only the Sensu Enterprise service (`sensu-enterprise`) requires access. All of the Sensu services for a given Sensu Core or Sensu Enterprise installation that require access to Redis **must use the same instance of Redis**, this includes distributed or HA Sensu Core and Sensu Enterprise configurations. Sensu uses Redis to store and access the Sensu client registry, check results, check execution history, and current event data.

# Anatomy of a Redis definition

The Redis definition uses the `"redis": {}` definition scope.

### Definition attributes

host
: description
  : The Redis instance hostname or IP address (recommended).
: required
  : false
: type
  : String
: default
  : `127.0.0.1`
: example
  : ~~~ shell
    "host": "8.8.8.8"
    ~~~

port
: description
  : The Redis instance TCP port.
: required
  : false
: type
  : Integer
: default
  : `6379`
: example
  : ~~~ shell
    "port": 6380
    ~~~

password
: description
  : The Redis instance authentication password.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "password": "secret"
    ~~~

db
: description
  : The Redis instance DB to use/select (numeric index).
: required
  : false
: type
  : Integer
: default
  : `0`
: example
  : ~~~ shell
    "db": 1
    ~~~

auto_reconnect
: description
  : Reconnect to Redis in the event of a connection failure.
: required
  : false
: type
  : Boolean
: default
  : `true`
: example
  : ~~~ shell
    "auto_reconnect": false
    ~~~

reconnect_on_error
: description
  : Reconnect to Redis in the event of a Redis error, e.g. READONLY (not to be confused with a connection failure).
: required
  : false
: type
  : Boolean
: default
  : `false`
: example
  : ~~~ shell
    "reconnect_on_error": true
    ~~~

# Configuring Redis

To configure Redis, please refer to the [official Redis configuration documentation](http://redis.io/topics/config).

# Security

Redis is designed to be accessed by trusted clients inside trusted environments. Access to the Redis TCP port (default is `6379`) should be limited, this can be accomplished with firewall rules (e.g. IPTables, EC2 security group). Redis does not support native SSL encryption, however, a SSL proxy like [Stunnel](https://www.stunnel.org/index.html) may be used to provide an encrypted tunnel, at the cost of added complexity. Redis does not provide access controls, however, it does support plain-text password authentication. Redis password authentication may be limited but it is recommended.

For more on Redis security, please refer to the [official Redis security documentation](http://redis.io/topics/security).
