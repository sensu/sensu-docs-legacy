---
layout: default
title: Mutators
description: Sensu mutators
version: 0.9
---

# Sensu mutators

## What are mutators?
Mutators are handler-specific data massagers that can alter event data
before it is passed to a [handler](/{{ page.version }}/handlers.html).

This is in effect what's happening:

{% highlight bash %}
cat event.json | mutator.rb | handler.rb
{% endhighlight %}

## Example
Here is an example that takes in event data, tags it, and spits out the
modified data to `STDOUT` for the handler to consume.

### An event mutator (/etc/sensu/mutators/tag.rb)

{% highlight ruby %}
#!/usr/bin/env ruby

require 'rubygems'
require 'json'

# Read event data
event = JSON.parse(STDIN.read, :symbolize_names => true)
# Add a 'tag' to prove it has been mutated
event.merge!(:mutated => true, :its_a_tumor => true)
# Output mutated event data to STDOUT
puts event.to_json
{% endhighlight %}

### Mutator definition (configuration)

{% highlight json %}
{
  "mutators": {
    "tag": {
      "command": "/etc/sensu/mutators/tag.rb"
    }
  }
}
{% endhighlight %}

### Use the mutator for a specific handler

{% highlight json %}
{
  "handlers": {
    "file": {
      "type": "pipe",
      "mutator": "tag",
      "command": "/etc/sensu/handlers/file.rb"
    }
  }
}
{% endhighlight %}

## Built-in mutators
There are a few built-in mutators that do not require definitions.

### Only check output
Only pass check output from event data to a handler.

{% highlight json %}
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
{% endhighlight %}

