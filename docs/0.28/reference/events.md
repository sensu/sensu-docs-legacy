---
title: "Events"
description: "Reference documentation for Sensu Events, including the Event
  Data specification."
version: 0.28
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
    - [`EVENT` attributes](#event-attributes)
    - [`check` attributes](#check-attributes)
    - [`client` attributes](#client-attributes)

## What are Sensu events? {#what-are-sensu-events}

Sensu events are created to acknowledge that something potentially noteworthy
has occurred, which events may then be processed by one or more [event
handlers][1] to do things such as send an email, or invoke an automated action.
Every Sensu event provides context, called ["event data"][2], which contains
information about the originating [Sensu client][3] and the corresponding [check
result][4].

### How are Sensu events created?

A Sensu Event is created every time a [check result][10] is processed by the
Sensu server, regardless of the status indicated by the check result. An Event
is created by collating data from the check result, the [client registry][22]
and additional context added at the time of processing.

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
      "type": "standard",
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
      "version": "0.28.0",
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

#### `EVENT` attributes

The following attributes are available in the root scope of the event data JSON
document:

`id`
: description
  : Persistent unique ID for the event.
: type
  : String
: possible values
  : Any [Ruby `SecureRandom.uuid` value][7]
: example
  : ~~~ shell
    "id": "66926524-da77-41a4-92bd-365498841079"
    ~~~

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
  : The Sensu event action, providing event handlers with more information about
    the state change.
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
  : The occurrence count for the event; the number of times an event has been
    created for a client/check pair with the same state (check status).
: type
  : Integer
: default
  : `1`
: example
  : ~~~ shell
    "occurrences": 3
    ~~~

`occurrences_watermark`
: description
  : The "high water mark" tracking number of occurrences at the current severity.
: type
  : Integer
: default
  : `1`
: example
  : ~~~ shell
    "occurrences_watermark": 3
    ~~~

`check`
: description
  : The check result [check attributes][8].
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
  : [Client attributes][9] from the originating client, or the proxy client
    attributes, in the case of an event from a proxy client.
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

`silenced`
: description
: type
: example

`silenced_by`
: description
  : List of silence entry IDs which match this event
: type
  : Array
: example
  : ~~~ json
    [ "load-balancer:check_ntp" ]
    ~~~

#### `check` attributes

The following attributes are available in the `{ "check": {} }` scope of the
event data JSON document.

_NOTE: In general, event data check attributes are fetched from [Check result
data][10] during event processing, which check result will include any [check
definition attribute][11] (which may include [custom check definition
attributes][12]). The following specification only documents the standard set of
check attributes which may be expected in an event data payload._


`type`
: description
  : The check type.
: default
  : `standard`
: allowed values
  : `standard`, `metric`
: type
  : String
: example
  : ~~~ shell
    "type": "standard"
    ~~~

`name`
: description
  : The `name` as defined in the originating [check definition][11].
: type
  : String
: required
  : `true`
: example
  : ~~~ shell
    "name": "sensu_website"
    ~~~

`command`
: description
  : The `command` as defined in the originating [check definition][11].
: type
  : String
: required
  : `true`
: example
  : ~~~ shell
    "command": "check-http.rb -u https://sensuapp.org"
    ~~~

`subscribers`
: description
  : The `subscribers` as defined in the originating [check definition][11].
: type
  : Array
: required
  : `true`
: example
  : ~~~ shell
    "subscribers": [
      "webserver"
    ]
    ~~~

`interval`
: description
  : The `interval`, in seconds, as defined in the originating [check
    definition][11].
: type
  : Integer
: required
  : `true`
: example
  : ~~~ shell
    "interval": 30
    ~~~

`handler`
: description
  : The `handler` as defined in the originating [check definition][11].
: type
  : String
: required
  : `false`
: example
  : ~~~ shell
    "handler": "slack"
    ~~~

`handlers`
: description
  : The `handlers` as defined in the originating [check definition][11].
: type
  : Array
: required
  : `false`
: example
  : ~~~ shell
    "handlers": [
      "slack"
    ]
    ~~~

`issued`
: description
  : The `issued` timestamp (in [epoch time][13]), when Sensu issued the check
    request (for a subscription check or standalone check).
: type
  : Integer
: required
  : `false`
: example
  : ~~~ shell
    "issued": 1326390159
    ~~~

`output`
: description
  : The `output` produced by the check, as included in the [check result][10].
: type
  : String
: required
  : `true`
: example
  : ~~~ shell
    "output": "CheckHttp OK: 200, 78572 bytes\n"
    ~~~

`status`
: description
  : The [exit status code][14] produced by the check, as included in the [check
    result][10].
: type
  : Integer
: required
  : `true`
: example
  : ~~~ shell
    "status": 0
    ~~~

`history`
: description
  : The history of the last 21 exit status codes produced by the check, as
    included in the [check result][10].
: type
  : Array
: required
  : `true`
: example
  : ~~~ shell
    "history": [0,0,0,0,0,0,1,2,2,0,0,0,0,0,0,0,0,0,0,0,0]
    ~~~

`source`
: description
  : The name of the [proxy client][15] to associate the event with, as included
    in the [check result][10] (`source` attribute).
    _NOTE: the `source` attribute may be included in [check definitions][11], or
    provided in check results published to the [Sensu client input socket][16]._
: type
  : String
: required
  : false
: example
  : ~~~ shell
    "source": "sensuapp.org"
    ~~~

`origin`
: description
  : The `name` of the Sensu client that executed the check.
    _NOTE: this attribute is only provided for proxy client events (i.e. events
    containing a `source` attribute._
: type
  : String
: required
  : false
: example
  : ~~~ shell
    "origin": "i-424242"
    ~~~

#### `client` attributes

The following attributes are available in the `{ "client": {} }` scope of the
event data JSON document.

_NOTE: In general, event data client attributes are fetched from the [Clients
API][17] during event processing, including any [client definition
attribute][18] (which may include [custom client definition attributes][19]).
The following specification only documents the standard set of check attributes
which may be expected in an event data payload._

`name`
: description
  : The `name` of the Sensu client (or [proxy client][15]) the event is
    associated with, as fetched from the [Clients API][17].
: type
  : String
: required
  : true
: example
  : ~~~ shell
    "name": "1-424242"
    ~~~

`address`
: description
  : The `address` of the Sensu client (or [proxy client][15]) the event is
    associated with, as fetched from the [Clients API][17].
: type
  : String
: required
  : true
: example
  : ~~~ shell
    "address": "10.0.2.100"
    ~~~

`subscriptions`
: description
  : The `subscriptions` the associated Sensu client (or [proxy client][15]) is a
    member of, as fetched from the [Clients API][17].
: type
  : Array
: required
  : true
: example
  : ~~~ shell
    "subscriptions": [
      "webserver"
    ]
    ~~~

`timestamp`
: description
  : The last [keepalive][20] `timestamp` (in [epoch time][13]) produced by the
    Sensu client (or [proxy client][15]), as fetched from the [Clients API][17].
    _NOTE: for proxy clients, this will usually represent the date/time when the
    proxy client was created, unless some external process is updating proxy
    client data via the [Clients API (POST)][21]._
: type
  : Integer
: required
  : true
: example
  : ~~~ shell
    "timestamp": 1326390159
    ~~~



[1]:  handlers.html
[2]:  #event-data
[3]:  checks.html
[4]:  checks.html#check-results
[5]:  #event-data-specification
[6]:  https://en.wikipedia.org/wiki/Unix_time
[7]:  http://ruby-doc.org/stdlib-2.3.0/libdoc/securerandom/rdoc/SecureRandom.html
[8]:  #check-attributes
[9]:  #client-attributes
[10]: checks.html#check-results
[11]: checks.html#check-definition-specification
[12]: checks.html#custom-attributes
[13]: https://en.wikipedia.org/wiki/Unix_time
[14]: checks.html#sensu-check-specification
[15]: clients.html#proxy-clients
[16]: clients.html#client-socket-input
[17]: ../api/clients-api.html
[18]: clients.html#client-definition-specification
[19]: clients.html#custom-attributes
[20]: clients.html#client-keepalives
[21]: ../api/clients-api.html#clients-post
[22]: clients.html#registration-and-registry
