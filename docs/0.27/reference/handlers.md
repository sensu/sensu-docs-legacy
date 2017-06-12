---
title: "Handlers"
description: "Reference documentation for Sensu Handlers."
version: 0.27
weight: 8
---

# Sensu Event Handlers

## Reference documentation

- [What is a Sensu event handler?](#what-is-a-sensu-event-handler)
  - [Handler types](#handler-types)
  - [The default handler](#the-default-handler)
- [Pipe handlers](#pipe-handlers)
  - [Pipe handler commands](#pipe-handler-commands)
    - [What is a pipe handler command?](#what-is-a-pipe-handler-command)
    - [Pipe handler command arguments](#pipe-handler-command-arguments)
    - [How and where are pipe handler commands executed?](#how-and-where-are-pipe-handler-commands-executed)
- [TCP/UDP handlers](#tcpudp-handlers)
- [Transport handlers](#transport-handlers)
- [Handler sets](#handler-sets)
- [Handler configuration](#handler-configuration)
  - [Example handler definition](#example-handler-definition)
  - [Handler definition specification](#handler-definition-specification)
    - [Handler name(s)](#handler-names)
    - [`HANDLER` attributes](#handler-attributes)
    - [`socket` attributes (TCP/UDP handlers)](#socket-attributes)
    - [`pipe` attributes (Transport handlers)](#pipe-attributes)s

## What is a Sensu event handler?

Sensu event handlers are actions executed by the [Sensu server][1] on
[events][2], such as sending an email alert, creating or resolving an incident
(e.g. in PagerDuty, ServiceNow, etc), or storing metrics in a time-series
database (e.g. Graphite).

### Handler types

There are several types of handlers. The most common handler type is the `pipe`
handler, which works very similarly to how [checks][3] work, enabling Sensu to
interact with almost any computer program via [standard streams][4].

- **Pipe handlers**. Pipe handlers pipe event data into arbitrary commands via
  `STDIN`.
- **TCP/UDP handlers**. TCP and UDP handlers send event data to a remote socket
  (e.g. external API).
- **Transport handlers**. Transport handlers publish event data to the [Sensu
  transport][5].
- **Handler sets**. Handler sets (also called "set handlers") are used to group
  event handlers, making it easy to manage groups of actions that should be
  executed for certain types of events.

### The default handler

Sensu expects all [events][2] to have a corresponding handler. Event handler(s)
may be configured in [check definitions][16], however if no `handler` or
`handlers` have been configured, Sensu will attempt to handle the event using a
handler [named][15] `default`. The `default` handler is only a reference
(i.e. Sensu does not provide a built-in `default` handler), so if no handler
definition exists for a handler named `default`, Sensu will log an error
indicating that the event was not handled because a `default` handler definition
does not exist. To use one or more existing handlers as the `default`, you can
create a [Set handler][17] called `default` and include the existing handler(s)
in the set.

## Pipe handlers

Pipe handlers are external commands that can consume [event data][6] via STDIN.

### Example pipe handler definition

~~~ json
{
  "handlers": {
    "example_pipe_handler": {
      "type": "pipe",
      "command": "do_something_awesome.rb -o options"
    }
  }
}
~~~

### Pipe handler commands

#### What is a pipe handler command?

Pipe handler definitions include a `command` attribute which are literally
executable commands which will be executed on a [Sensu server][1] as the `sensu`
user.

#### Pipe handler command arguments

Pipe handler `command` attributes may include command line arguments for
controlling the behavior of the `command` executable. Most [Sensu handler
plugins][11] provide support for command line arguments for reusability.

#### How and where are pipe handler commands executed?

As mentioned above, all pipe handlers are executed by a [Sensu server][1] as the
`sensu` user. Commands must be executable files that are discoverable on the
Sensu server system (i.e. installed in a system [`$PATH` directory][7]).

_NOTE: By default, the Sensu installer packages will modify the system `$PATH`
for the Sensu processes to include `/etc/sensu/plugins`. As a result, executable
scripts (e.g. plugins) located in `/etc/sensu/plugins` will be valid commands.
This allows `command` attributes to use "relative paths" for Sensu plugin
commands; <br><br>e.g.: `"command": "handler-irc.rb"`_


## TCP/UDP handlers

TCP and UDP handlers enable Sensu to forward event data to arbitrary [TCP or UDP
sockets][t] for external services to consume (e.g. third-party APIs).

### Example TCP handler definition

The following example TCP handler definition will forward [event data][6] to a
[TCP socket][8] (i.e. `10.0.1.99:4444`) and will `timeout` if an acknowledgement
(`ACK`) is not received within 30 seconds.

~~~ json
{
  "handlers": {
    "example_tcp_handler": {
      "type": "tcp",
      "timeout": 30,
      "socket": {
        "host": "10.0.1.99",
        "port": 4444
      }
    }
  }
}
~~~

The following example UDP handler definition will forward [event data][6] to a
UDP socket (i.e. `10.0.1.99:444`).

~~~ json
{
  "handlers": {
    "example_udp_handler": {
      "type": "udp",
      "socket": {
        "host": "10.0.1.99",
        "port": 4444
      }
    }
  }
}
~~~

## Transport handlers

Transport handlers enable Sensu to publish event data to named queues on the
[Sensu transport][5] for external services to consume.

### Example transport handler definition

The following example transport handler definition will publish [event data][6]
to the Sensu transport on a pipe (e.g. a "queue" or "channel", etc) named
`example_handler_queue`. One or more instances of an external process or
third-party application would need to subscribe to the named pipe to process the
events.

~~~ json
{
  "handlers": {
    "example_transport_handler": {
      "type": "transport",
      "pipe": {
        "type": "direct",
        "name": "example_handler_queue"
      }
    }
  }
}
~~~

## Handler sets

Handler set definitions allow groups of handlers (i.e. individual collections of
actions to take on event data) to be referenced via a single named handler set.

_NOTE: Attributes defined on handler sets do not apply to the handlers they
include. For example, `filter`, `filters`, and `mutator` attributes defined 
in a handler set will have no effect._

### Example handler set definition

The following example handler set definition will execute three handlers (i.e.
`email`, `slack`, and `pagerduty`) for every event.

~~~ json
{
  "handlers": {
    "notify_all_the_things": {
      "type": "set",
      "handlers": [
        "email",
        "slack",
        "pagerduty"
      ]
    }
  }
}
~~~

## Handler configuration

### Example handler definition

The following is an example Sensu handler definition, a JSON configuration file
located at `/etc/sensu/conf.d/mail_handler.json`. This handler definition uses
the `mailx` unix command, to email the event data to `example@address.com`, with
the email subject `sensu event`. The handler is named `mail`.

~~~ json
{
  "handlers": {
    "mail": {
      "type": "pipe",
      "command": "mailx -s 'sensu event' example@address.com"
    }
  }
}
~~~

### Handler definition specification

#### Handler name(s)

Each handler definition has a unique handler name, used for the definition key.
Every handler definition is within the `"handlers": {}` [configuration
scope][9].

- A unique string used to name/identify the check
- Cannot contain special characters or spaces
- Validated with [Ruby regex][10] `/^[\w\.-]+$/.match("handler-name")`

#### `HANDLER` attributes

The following attributes are configured within the `{"handlers": { "HANDLER": {}
} }` [configuration scope][9] (where `HANDLER` is a valid [handler name][15]).

`type`
: description
  : The handler type.
: required
  : true
: type
  : String
: allowed values
  : `pipe`, `tcp`, `udp`, `transport`, `set`
: example
  : ~~~ shell
    "type": "pipe"
    ~~~

`filter`
: description
  : The Sensu event filter (name) to use when filtering events for the handler.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "filter": "recurrence"
    ~~~

`filters`
: description
  : An array of Sensu event filters (names) to use when filtering events for the
    handler. Each array item must be a string.
: required
  : false
: type
  : Array
: example
  : ~~~ shell
    "filters": ["recurrence", "production"]
    ~~~

`severities`
: description
  : An array of check result severities the handler will handle.
    _NOTE: event resolution bypasses this filtering._
: required
  : false
: type
  : Array
: allowed values
  : `warning`, `critical`, `unknown`
: example
  : ~~~ shell
    "severities": ["critical", "unknown"]
    ~~~

`mutator`
: description
  : The Sensu event mutator (name) to use to mutate event data for the handler.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "mutator": "only_check_output"
    ~~~

`timeout`
: description
  : The handler execution duration timeout in seconds (hard stop). Only used by
    `pipe` and `tcp` handler types.
: required
  : false
: type
  : Integer
: default
  : `10`
: example
  : ~~~ shell
    "timeout": 30
    ~~~

`handle_silenced`
: description
  : If events matching one or more silence entries should be handled.
: required
  : false
: type
  : Boolean
: default
  : false
: example
  : ~~~ shell
    "handle_silenced": true
    ~~~

`handle_flapping`
: description
  : If events in the flapping state should be handled.
: required
  : false
: type
  : Boolean
: default
  : false
: example
  : ~~~ shell
    "handle_flapping": true
    ~~~

`command`
: description
  : The handler command to be executed. The event data is passed to the process
    via `STDIN`.
    _NOTE: the `command` attribute is only supported for Pipe handlers (i.e.
    handlers configured with `"type": "pipe"`)._
: required
  : true (if `type` == `pipe`)
: type
  : String
: example
  : ~~~ shell
    "command": "/etc/sensu/plugins/pagerduty.rb"
    ~~~

`socket`
: description
  : The [`socket` definition scope][13], used to configure the TCP/UDP handler
    socket.
    _NOTE: the `socket` attribute is only supported for TCP/UDP handlers (i.e.
    handlers configured with `"type": "tcp"` or `"type": "udp"`)._
: required
  : true (if `type` == `tcp` or `udp`)
: type
  : Hash
: example
  : ~~~ shell
    "socket": {}
    ~~~

`pipe`
: description
  : The [`pipe` definition scope][14], used to configure the Sensu transport
    pipe.
    _NOTE: the `pipe` attribute is only supported for Transport handlers (i.e.
    handlers configured with `"type": "transport"`)._
: required
  : true (if `type` == `transport`)
: type
  : Hash
: example
  : ~~~ shell
    "pipe": {}
    ~~~

`handlers`
: description
  : An array of Sensu event handlers (names) to use for events using the handler
    set. Each array item must be a string.
    _NOTE: the `handlers` attribute is only supported for handler sets (i.e.
    handlers configured with `"type": "set"`)._
: required
  : true (if `type` == `set`)
: type
  : Array
: example
  : ~~~ shell
    "handlers": ["pagerduty", "email", "ec2"]
    ~~~

#### `socket` attributes

The following attributes are configured within the `{"handlers": { "HANDLER": {
"socket": {} } } }` [configuration scope][9] (where `HANDLER` is a valid
[handler name][15]).

_NOTE: `socket` attributes are **only supported for TCP/UDP handlers** (i.e.
handlers configured with `"type": "tcp"` or `"type": "udp"`)._

##### EXAMPLE {#socket-attributes-example}

~~~ json
{
  "handlers": {
    "example_handler": {
      "type": "tcp",
      "socket": {
        "host": "10.0.5.100",
        "port": 8000
      }
    }
  }
}
~~~

##### ATTRIBUTES {#socket-attributes-specification}

`host`
: description
  : The socket host address (IP or hostname) to connect to.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "host": "8.8.8.8"
    ~~~

`port`
: description
  : The socket port to connect to.
: required
  : true
: type
  : Integer
: example
  : ~~~ shell
    "port": 4242
    ~~~

#### `pipe` attributes

The following attributes are configured within the `{"handlers": { "HANDLER": {
"pipe": {} } } }` [configuration scope][9] (where `HANDLER` is a valid [handler
name][15]).

_NOTE: `pipe` attributes are **only supported for Transport handlers** (i.e.
handlers configured with `"type": "transport"`)._

##### EXAMPLE {#pipe-attributes-example}

~~~ json
{
  "handlers": {
    "example_handler": {
      "type": "transport",
      "pipe": {
        "type": "topic",
        "name": "example_transport_handler"
      }
    }
  }
}
~~~

##### ATTRIBUTES {#pipe-attributes-specification}

`type`
: description
  : The Sensu transport pipe type.
: required
  : true
: type
  : String
: allowed values
  : `direct`, `fanout`, `topic`
: example
  : ~~~ shell
    "type": "direct"
    ~~~

_NOTE: types `direct`, `fanout` and `topic` are supported by the default
RabbitMQ transport. Redis and other transports may only implement a subset of
these._

`name`
: description
  : The Sensu transport pipe name.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "name": "graphite_plaintext"
    ~~~

`options`
: description
  : The Sensu transport pipe options. These options may be specific to the Sensu
    transport in use.
: required
  : false
: type
  : Hash
: default
  : `{}`
: example
  : ~~~ shell
    "options": {"durable": true}
    ~~~



[?]:  #
[1]:  server.html
[2]:  events.html
[3]:  checks.html
[4]:  https://en.wikipedia.org/wiki/Standard_streams
[5]:  transport.html
[6]:  events.html#event-data
[7]:  https://en.wikipedia.org/wiki/PATH_(variable)
[8]:  https://en.wikipedia.org/wiki/Network_socket
[9]:  configuration.html#configuration-scopes
[10]: http://ruby-doc.org/core-2.2.0/Regexp.html
[11]: plugins.html
[13]: #socket-attributes
[14]: #pipe-attributes
[15]: #handler-names
[16]: checks#check-definition-specification
[17]: #handler-sets
