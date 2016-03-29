---
version: 0.22
category: "Reference Docs"
title: "Mutators"
next:
  url: "extensions"
  text: "Extensions"
---

# Sensu Mutators

This reference document provides information to help you:

- Understand what a Sensu mutator is
- How a Sensu mutator works
- Write a Sensu mutator definition
- Use Sensu mutator definition attributes

## What are Sensu mutators? {#what-are-sensu-mutators}

Sensu mutators mutate (transform) event data for a Sensu event handler. Sensu event handlers can expect event data be in a different format and/or manipulated. Mutators allow one or more handlers to share logic, reducing code duplication, and simplifying the event handlers. Sensu mutators are executed on machines running the Sensu server or Sensu Enterprise. Mutators are essentially commands (or scripts) that receive JSON formatted event data via `STDIN` and output the mutated event data to `STDOUT`. Mutators use an exit status code of `0` to indicate a success, anything else indicates a failure. If a mutator fails to execute (non-zero exit status code), the event will not be handled, and an error will be logged.

### Example mutator plugin {#example-mutator-plugin}

The following is an example Sensu mutator plugin, a script located at `/etc/sensu/plugins/mutated.rb`. This mutator plugin reads the standard JSON event data from `STDIN`, parses it, and then adds `:mutated => true` before outputting it to `STDOUT`. This mutator plugin is written in Ruby, but Sensu plugins can be written in any language, e.g. Python, shell, etc.

~~~ ruby
#!/usr/bin/env ruby

require 'rubygems'
require 'json'

# Read the JSON event data from STDIN.
event = JSON.parse(STDIN.read, :symbolize_names => true)

# Add a key/value pair to indicate that the event data has been mutated.
event.merge!(:mutated => true)

# Convert the mutated event data back to JSON and output it to STDOUT.
puts JSON.dump(event)
~~~

## Mutator definition

A Sensu mutator definition is a JSON configuration file describing a Sensu mutator. A definition declares how a Sensu mutator is executed:

- The command to run (e.g. script)

### Example mutator definition {#example-mutator-definition}

The following is an example Sensu mutator definition, a JSON configuration file located at `/etc/sensu/conf.d/mutated.json`. This mutator definition uses the [example mutator plugin](#example-mutator-plugin) above, to add a key/value pair to the event data. The mutator is named `mutated` and it runs `/etc/sensu/plugins/mutated.rb`.

~~~ json
{
  "mutators": {
    "mutated": {
      "command": "/etc/sensu/plugins/mutated.rb"
    }
  }
}
~~~

## Anatomy of a mutator definition

### Name

Each mutator definition has a unique mutator name, used for the definition key. Every mutator definition is within the `"mutators": {}` definition scope.

- A unique string used to name/identify the mutator
- Cannot contain special characters or spaces
- Validated with `/^[\w\.-]+$/`
- e.g. `"mutated": {}`

### Definition attributes

command
: description
  : The mutator command to be executed. The event data is passed to the process via `STDIN`.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "command": "/etc/sensu/plugins/mutated.rb"
    ~~~

timeout
: description
  : The mutator execution duration timeout in seconds (hard stop).
: required
  : false
: type
  : Integer
: example
  : ~~~ shell
    "timeout": 30
    ~~~
