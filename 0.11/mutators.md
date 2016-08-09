---
version: "0.11"
category: "Configuration"
title: "Mutators"
---

# Sensu mutators

Mutators are handler-specific data massagers that can alter event data
before it is passed to a [handler](/{{ page.version }}/handlers.html).

This is in effect what's happening:

~~~ bash
cat event.json | mutator.rb | handler.rb
~~~

## Example

Here is an example that takes in event data, tags it, and spits out the
modified data to `STDOUT` for the handler to consume. This event mutator
is stored in `/etc/sensu/mutators/tag.rb`

~~~ ruby
#!/usr/bin/env ruby

require 'rubygems'
require 'json'

# Read event data
event = JSON.parse(STDIN.read, :symbolize_names => true)
# Add a 'tag' to prove it has been mutated
event.merge!(:mutated => true, :its_a_tumor => true)
# Output mutated event data to STDOUT
puts event.to_json
~~~

## Mutator definition

~~~ json
{
  "mutators": {
    "tag": {
      "command": "/etc/sensu/mutators/tag.rb"
    }
  }
}
~~~

## Use the mutator for a specific handler

~~~ json
{
  "handlers": {
    "file": {
      "type": "pipe",
      "mutator": "tag",
      "command": "/etc/sensu/handlers/file.rb"
    }
  }
}
~~~

## Built-in mutators

There are a few built-in mutators that do not require definitions.

### Only check output
Only pass check output from event data to a handler.

~~~ json
{
  "handlers": {
    "graphite": {
      "type": "tcp",
      "mutator": "only_check_output",
      "socket": {
        "host": "127.0.0.1",
        "port": 2003
      }
    }
  }
}
~~~

