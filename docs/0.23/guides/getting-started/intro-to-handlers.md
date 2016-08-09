---
title: "Intro to Handlers"
version: 0.23
weight: 4
next:
  url: "intro-to-filters.html"
  text: "Getting Started with Filters"
---

# Getting Started with Handlers

The purpose of this guide is to help Sensu users create event handlers. At the
conclusion of this guide, you - the user - should have several Sensu handlers in
place to handle events. Each Sensu event handler in this guide demonstrates one
or more handler types and definition features, for more information please refer
to the [handlers reference documentation][1].

## Objectives

What will be covered in this guide:

- Creation of a **pipe** handler
- Creation of a **tcp** handler
- Creation of a **udp** handler
- Creation of a **transport** handler
- Creation of a **set** handler

## What are Sensu event handlers? {#what-are-sensu-event-handlers}

Sensu event handlers are for taking action on [events][2] (produced by check
results), such as sending an email alert, creating or resolving a PagerDuty
incident, or storing metrics in Graphite. There are several types of handlers:
`pipe`, `tcp`, `udp`, `transport`, and `set`.

- **Pipe handlers** execute a command and pass the event data to the created
  process via `STDIN`.
- **TCP and UDP handlers** send the event data to a remote socket.
- **Transport handlers** publish the event data to the Sensu transport (by
  default, this is RabbitMQ).
- **Set handlers** are used to group event handlers, making it easier to manage
  many event handlers.

## Create a pipe handler

Pipe event handlers execute a command and pass the event data to the
corresponding process via `STDIN`.

### Install dependencies

The following instructions install the `event-file` Sensu handler plugin
(written in Ruby) to `/etc/sensu/plugins/event-file.rb`. This handler plugin
reads the event data via `STDIN`, parses it, creates a file name using the
parsed event data, and then writes the event data to the file (e.g.
`/tmp/client_name/check_name.json`).

~~~ shell
sudo wget -O /etc/sensu/plugins/event-file.rb http://sensuapp.org/docs/0.23/files/event-file.rb
sudo chmod +x /etc/sensu/plugins/event-file.rb
~~~

The `event-file` Sensu plugin requires a Ruby runtime. Install Ruby from the
distribution repository and `sensu-plugin` from Rubygems:

_NOTE: the following Ruby installation steps may differ depending on your
platform. You may have already done the following steps as part of the [getting
started with checks guide][3]._

#### Ubuntu/Debian

~~~ shell
sudo apt-get update
sudo apt-get install ruby ruby-dev
~~~

#### CentOS/RHEL

~~~ shell
sudo yum install ruby ruby-devel
~~~

### Create the pipe handler definition

The following is an example Sensu handler definition, a JSON configuration file
located at `/etc/sensu/conf.d/event_file.json`. This handler definition uses the
`event-file` plugin ([installed above][4]) to write event data to a file. The
handler is named `file` and it runs `/etc/sensu/plugins/event-file.rb`,
providing it with JSON event data via `STDIN`.

_NOTE: Sensu services must be restarted in order to pick up configuration
changes. Sensu Enterprise can be reloaded._

~~~ json
{
  "handlers": {
    "file": {
      "type": "pipe",
      "command": "/etc/sensu/plugins/event-file.rb"
    }
  }
}
~~~

To add a handler execution timeout to the `file` handler, use the `timeout`
attribute.

~~~ json
{
  "handlers": {
    "file": {
      "type": "pipe",
      "command": "/etc/sensu/plugins/event-file.rb",
      "timeout": 10
    }
  }
}
~~~

To specify which check result severities (`OK`, `WARNING`, etc.) the handler
supports, use the `severities` attribute.

~~~ json
{
  "handlers": {
    "file": {
      "type": "pipe",
      "command": "/etc/sensu/plugins/event-file.rb",
      "timeout": 10,
      "severities": ["critical", "unknown"]
    }
  }
}
~~~

To use the `file` handler for a check, please refer to the [getting started with
checks guide][5].

## Create a TCP handler

TCP and UDP event handlers send event data to a remote socket. Both TCP and UDP
handler types use the same definition attributes. The following TCP handler
instructions will work for UDP with minor adjustments.

Because TCP and UDP handlers require interaction with an external service,
providing a functional example is outside of the scope of this guide. However,
the following instructions will allow you to run a simple TCP socket that echoes
any input to `STDOUT` for testing purposes.

### Run a TCP server

To test the TCP handler, a listening TCP socket server is required. For the
following examples, netcat (`nc`) will be used as the TCP server.

The following command will create a TCP socket server listening on port 6000.

_NOTE: netcat will output messages that it receives in the terminal window. This
command will need to be run in a separate terminal window._

~~~ shell
nc -l -k -4 -p 6000
~~~

To test the netcat TCP socket server, run the following command and observe the
netcat output (`testing`).

~~~ shell
echo "testing" | nc localhost 6000
~~~

### Create the TCP handler definition

The following is an example Sensu handler definition, a JSON configuration file
located at `/etc/sensu/conf.d/tcp_socket.json`. This TCP handler will send JSON
event data to the TCP socket server (netcat in this example).

_NOTE: Sensu services must be restarted in order to pick up configuration
changes. Sensu Enterprise can be reloaded._

~~~ json
{
  "handlers": {
    "tcp_socket": {
      "type": "tcp",
      "socket": {
        "host": "localhost",
        "port": 6000
      }
    }
  }
}
~~~

## Create a transport handler

Transport handlers publish event data to the Sensu transport (by default this is
RabbitMQ). Transport event handlers are used to deliver event data to other
services, using the Sensu transport.

### Create the transport handler definition

The following is an example Sensu handler definition, a JSON configuration file
located at `/etc/sensu/conf.d/transport_events.json`. This transport handler
will publish JSON event data to the Sensu transport.

_NOTE: Sensu services must be restarted in order to pick up configuration
changes. Sensu Enterprise can be reloaded._

~~~ json
{
  "handlers": {
    "transport": {
      "type": "transport",
      "pipe": {
        "type": "direct",
        "name": "events"
      }
    }
  }
}
~~~

## Create a set handler

Set handlers are used to group event handlers into _sets of handlers_, making it
easier to reference a set of event handlers from a check definition.

### Create the set handler definition

The following is an example Sensu handler definition, a JSON configuration file
located at `/etc/sensu/conf.d/default_handler.json`. This set handler is named
`default`, the handler that is used for events where a handler is not specified.
The previous Sensu event handler examples are included in the set.

_NOTE: Sensu services must be restarted in order to pick up configuration
changes. Sensu Enterprise can be reloaded._

~~~ json
{
  "handlers": {
    "default": {
      "type": "set",
      "handlers": [
        "debug",
        "file",
        "tcp_socket",
        "transport"
      ]
    }
  }
}
~~~

[1]:  ../../reference/handlers.html
[2]:  ../../reference/events.html
[3]:  intro-to-checks.html#install-dependencies
[4]:  #install-dependencies
[5]:  intro-to-checks.html#create-the-check-definition-for-cron
