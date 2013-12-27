---
version: "0.12"
category: "Configuration"
title: "Keepalives"
---

# Keepalive Checks

## What are keepalive checks?


Keepalive checks are integrated checks that monitor the communication
between Sensu clients and the Sensu server.

Clients publish keepalive status updates periodically, which are
processed and recorded by the server.  The server verifies that
all clients have published a keepalive within a configurable threshold,
and it escalates if there has been no client-server communication.

Keepalive checks handle basic monitoring scenarios, such as server
failure, excessive load, client misconfiguration, and network issues.

## Keepalive default configuration

Keepalive checks escalate via the 'default' handler set, and issue a
warning after 120 seconds without communication, and issue a critical
event after 180 seconds. Due to the periodic nature of both the
publishing and verification, there may be a few seconds of additional
time before the events are created and handled.

`"threshold"` is semantically equivalent to`"occurrences"`. Once an event threshold has been reached, notifications will continue to be sent every 120 events.

## Overriding Configuration

The default keepalive configuration is meant to be sufficient, however
these settings can be overridden on a per-client basic. This may be
desired to enable custom escalation scenarios, or perhaps account for
relative client-server network instability (i.e. across datacenters).

The keepalive configuration can be overridden using the same fields as
[checks](checks)

## Example Client Keepalive Settings (configuration)

This example will trigger a warning if the client does not check in
every 10 seconds, and a critical after 300 seconds.  The events will
be handled with the `screaming_monkey` and `email` handlers. The second
(and subsequent) notifications will be sent every 1800 seconds.

``` json
{
  "client": {
    "name": "i-424242",
    "address": "127.0.0.1",
    "keepalive": {
      "thresholds": {
        "warning": 10,
        "critical": 300
      },
      "handlers": ["screaming_monkey", "email"],
      "refresh": 1800
    }
  }
}
```
