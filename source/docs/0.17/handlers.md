---
version: 0.17
category: "Reference Docs"
title: "Handlers"
next:
  url: "filters"
  text: "Filters"
---

# Overview

This reference document provides information to help you:

- Understand what a Sensu event handler is
- How a Sensu event handler works
- Write a Sensu event handler definition

# What are Sensu event handlers? {#what-are-sensu-event-handlers}

Sensu event handlers are for taking action on [events](events) (produced by check results), such as sending an email alert, creating or resolving a PagerDuty incident, or storing metrics in Graphite. There are several types of handlers: `pipe`, `tcp`, `udp`, `transport`, and `set`. Pipe handlers execute a command and pass the event data to the created process via `STDIN`. TCP and UDP handlers send the event data to a remote socket. Transport handlers publish the event data to the Sensu transport (message bus). Set handlers are used to group event handlers, making it easier to manage many event handlers.

## Example handler plugin {#example-handler-plugin}

The following is an example Sensu handler plugin, a script located at `/etc/sensu/plugins/event-file.rb`. This handler plugin reads the event data via `STDIN`, parses it, creates a file name using the parsed event data, and then writes the event data to the file. This handler plugin is written in Ruby, but Sensu plugins can be written in any language, e.g. Python, shell, etc.

~~~ ruby
#!/usr/bin/env ruby

require 'rubygems'
require 'json'

# Read the JSON event data from STDIN.
event = JSON.parse(STDIN.read, :symbolize_names => true)

# Write the event data to a file.
# Using the client and check names in the file name.
file_name = "/tmp/sensu_#{event[:client][:name]}_#{event[:check][:name]}.json"

File.open(file_name, 'w') do |file|
  file.write(JSON.pretty_generate(event))
end
~~~

# Handler definition

A Sensu handler definition is a JSON configuration file describing a Sensu handler. A definition declares how a Sensu handler is executed:

- If there is a command to be run with event data provided via `STDIN`
- If there is a socket to send event data to
- If the event data is to be published to the Sensu transport (message bus)
- If there is a set of handlers to be executed

## Example handler definition {#example-handler-definition}

The following is an example Sensu handler definition, a JSON configuration file located at `/etc/sensu/conf.d/mail_handler.json`. This handler definition uses the `mailx` unix command, to email the event data to `example@address.com`, with the email subject `sensu event`. The handler is named `mail`.

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

# Anatomy of a handler definition

### Name

Each handler definition has a unique handler name, used for the definition key. Every handler definition is within the `"handlers": {}` definition scope.

- A unique string used to name/identify the handler
- Cannot contain special characters or spaces
- Validated with `/^[\w\.-]+$/`
- e.g. `"pagerduty": {}`

### Definition attributes

type
: description
  : The handler type. Each handler type has its own set of definition attributes, e.g. [pipe](#pipe-handler-attributes).
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

filter
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

filters
: description
  : An array of Sensu event filters (names) to use when filtering events for the handler. Each array item must be a string.
: required
  : false
: type
  : Array
: example
  : ~~~ shell
    "filters": ["recurrence", "production"]
    ~~~

severities
: description
  : An array of check result severities the handler will handle. Event resolution bypasses this filtering.
: required
  : false
: type
  : Array
: allowed values
  : `ok`, `warning`, `critical`, `unknown`
: example
  : ~~~ shell
    "severities": ["critical", "unknown"]
    ~~~

mutator
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

timeout
: description
  : The handler execution duration timeout in seconds (hard stop).
: required
  : false
: type
  : Integer
: example
  : ~~~ shell
    "timeout": 30
    ~~~

handle_flapping
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

subdue
: description
  : A set of attributes that determine when a handler is subdued.
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "subdue": {}
    ~~~

#### Pipe handler attributes

command
: description
  : The handler command to be executed. The event data is passed to the process via `STDIN`.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "command": "/etc/sensu/plugins/pagerduty.rb"
    ~~~

#### TCP & UDP handler attributes

socket
: description
  : A set of attributes that configure the TCP/UDP handler socket.
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "socket": {}
    ~~~

##### Socket attributes

host
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

port
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

#### Transport handler attributes

pipe
: description
  : A set of attributes that configure the Sensu transport pipe.
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "pipe": {}
    ~~~

##### Transport pipe attributes

type
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

name
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

options
: description
  : The Sensu transport pipe options. These options may be specific to the Sensu transport in use.
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

#### Set handler attributes

handlers
: description
  : An array of Sensu event handlers (names) to use for events using the handler set. Each array item must be a string.
: required
  : false
: type
  : Array
: example
  : ~~~ shell
    "handlers": ["pagerduty", "email", "ec2"]
    ~~~

#### Subdue attributes

The following attributes are configured within the `"subdue": {}` handler definition attribute context.

days
: description
  : An array of days of the week the handler is subdued. Each array item must be a string and a valid day of the week.
: required
  : false
: type
  : Array
: example
  : ~~~ shell
    "days": ["monday", "wednesday"]
    ~~~

begin
: description
  : Beginning of the time window when the handler is subdued. Parsed by Ruby's `Time.parse()`. Time may include a time zone.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "begin": "5PM PST"
    ~~~

end
: description
  : End of the time window when the handler is subdued. Parsed by Ruby's `Time.parse()`. Time may include a time zone.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "end": "9AM PST"
    ~~~

exceptions
: description
  : Subdue time window (`begin`, `end`) exceptions. An array of time window exceptions. Each array item must be a hash containing valid `begin` and `end` times.
: required
  : false
: type
  : Array
: example
  : ~~~ shell
    "exceptions": [{"begin": "8PM PST", "end": "10PM PST"}]
    ~~~
