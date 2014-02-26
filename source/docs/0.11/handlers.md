---
version: "0.11"
category: "Configuration"
title: "Handlers"
---

# Sensu handlers

## What are handlers?

Handlers are for taking action on [event data](events), such as sending an email alert, creating a PagerDuty incident, or storing metrics in Graphite.

## Types
There are several types of handlers.

### Pipe 

Pipe handlers are for executing a command (or script), passing it the
event data via `STDIN`. Here is an example that takes in event data, and
writes it to a file for inspection.

``` ruby
#!/usr/bin/env ruby

require 'rubygems'
require 'json'

# Read event data
event = JSON.parse(STDIN.read, :symbolize_names => true)
# Write the event data to a file
file_name = "/tmp/sensu_#{event[:client][:name]}_#{event[:check][:name]}"
File.open(file_name, 'w') do |file|
  file.write(JSON.pretty_generate(event))
end
```

#### Handler definition

``` json
{
  "handlers": {
    "file": {
      "type": "pipe",
      "command": "/etc/sensu/handlers/file.rb"
    }
  }
}
```

Here is an example that uses a `mail` to email the event data.

``` json
{
  "handlers": {
    "mail": {
      "type": "pipe",
      "command": "mail -s 'sensu event' email@address.com"
    }
  }
}
```

#### Handler configuration

Handlers using the `sensu-plugin` Rubygem have access to Sensu configs
that can be used to configure specific settings for the handlers.  The
settings access is generalized and flexible, although there is a
standard convention for configuring handlers that has developed
organically.

Here is a hypothetical JSON snippet that is defining and configuring two
custom handlers.  The handler `my_handler1` pulls configuration settings
from within the handler definition (probably with
`setttings['handlers']['my_handler1']['custom_setting']`).  The
handler `my_handler2` gets its configuration settings from a
top-level namespace (probably with
`setttings['my_handler2']['another_custom_setting']`).  

Both of these configuration methods work fine.  Configuring within the
handler definition in the `handlers` keeps things organized,
although the typical convention is to use a top-level namespace for each
handler.  Check in the handler itself to see how it is accessing
configuration values.

``` json
{
  "handlers": {
    "my_handler1": {
      "type": "pipe",
      "command": "/etc/sensu/handlers/file.rb",
      "custom_setting": "custom_val"
    },
    "my_handler2": {
      "type": "pipe",
      "command": "/etc/sensu/handlers/file.rb"
    }
  },
  "my_handler2": {
     "conventional_configuration": "true",
     "another_custom_setting": "some_custom_value"
   }
}
```

### TCP

TCP handlers are for writing event data to a TCP socket.

Here is an example that writes event data to a local TCP socket, port `4242`.

``` json
{
  "handlers": {
    "tcp_socket": {
      "type": "tcp",
      "socket": {
        "host": "127.0.0.1",
        "port": 4242
      }
    }
  }
}
```

### UDP

UDP handlers are for writing event data to a UDP socket.

Here is an example that writes event data to a local UDP socket, port `2424`.

``` json
{
  "handlers": {
    "udp_socket": {
      "type": "udp",
      "socket": {
        "host": "127.0.0.1",
        "port": 2424
      }
    }
  }
}
```

### AMQP

AMQP handlers are for publishing event data on an AMQP exchange.

Here is an example that publishes event data on an AMQP exchange (limited to the broker used by Sensu).

``` json
{
  "handlers": {
    "amqp_exchange": {
      "type": "amqp",
      "exchange": {
        "type": "topic",
        "name": "events"
      }
    }
  }
}
```

Refer to the Ruby AMQP library documentation on [working with
exchanges](http://rubyamqp.info/articles/working_with_exchanges/) for
exchange options.

### Set

Handler sets are for grouping handlers; a way to send the same event
data to one or more handlers, or simply create an alias.

``` json
{
  "handlers": {
    "default": {
      "type": "set",
      "handlers": [
        "file",
        "tcp_socket"
      ]
    }
  }
}
```

## Severity filtering

Handlers have the option to only handle events of a particular severity.
For example, the PagerDuty handler should only be used when an event has
a `CRITICAL` check exit status `2` or is `OK` and resolving an event `0`.

``` json
{
  "handlers": {
    "pagerduty": {
      "type": "pipe",
      "command": "/etc/sensu/handlers/pagerduty.rb",
      "severities": [
        "critical",
        "ok"
      ]
    }
  }
}
```

