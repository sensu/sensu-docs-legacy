---
version: 0.17
category: "Getting Started Guide"
title: "Getting Started with Handlers"
next:
  url: "getting-started-with-filters"
  text: "Getting Started w/ Filters"
---

# Overview

The purpose of this guide is to help Sensu users create event handlers. At the conclusion of this guide, you - the user - should have several Sensu handlers in place to handle events. Each Sensu event handler in this guide demonstrates one or more handler types and definition features, for more information please refer to the [handlers reference documentation](handlers).

## Objectives

What will be covered in this guide:

- Creation of a **pipe** handler
- Creation of a **tcp** handler
- Creation of a **udp** handler
- Creation of a **transport** handler
- Creation of a **set** handler

# What are Sensu event handlers? {#what-are-sensu-event-handlers}

Sensu event handlers are for taking action on [events](events) (produced by check results), such as sending an email alert, creating or resolving a PagerDuty incident, or storing metrics in Graphite. There are several types of handlers: `pipe`, `tcp`, `udp`, `transport`, and `set`. Pipe handlers execute a command and pass the event data to the created process via `STDIN`. TCP and UDP handlers send the event data to a remote socket. Transport handlers publish the event data to the Sensu transport (message bus). Set handlers are used to group event handlers, making it easier to manage many event handlers.

# Create a pipe handler

Pipe event handlers execute a command and pass the event data to the created process via `STDIN`.

### Install dependencies

The following instructions install the `event-file` Sensu handler plugin (written in Ruby) to `/etc/sensu/plugins/event-file.rb`. This handler plugin reads the event data via `STDIN`, parses it, creates a file name using the parsed event data, and then writes the event data to the file (e.g. `/tmp/client_name/check_name.json`).

~~~ shell
sudo wget -O /etc/sensu/plugins/event-file.rb http://sensuapp.org/docs/0.17/files/event-file.rb
sudo chmod +x /etc/sensu/plugins/event-file.rb
~~~

