---
version: 0.21
category: "Reference Docs"
title: "Plugins"
next:
  url: "clients"
  text: "Clients"
---

# Sensu Plugins

This reference document provides information to help you:

- [Understand what a Sensu Plugin is](#what-are-sensu-plugins)
- [Understand what `sensu-install` is](#what-is-sensu-install)
- [Use `sensu-install` to install a Sensu Plugin](#sensu-install-example)
- [Understand the Sensu Plugin spec](#sensu-plugin-spec)

## What are Sensu Plugins?

Sensu plugins enable you to monitor server resources, services, and application health, as well as collect & analyze metrics. Plugins provide scripts that output data to `STDOUT` or `STDERR` and produce an exit status code to indicate a state. The exit status codes used are `0` for `OK`, `1` for `WARNING`, `2` for `CRITICAL`, and `3` or greater to indicate `UNKNOWN` or `CUSTOM`. Sensu Plugins can provide scripts for Sensu [Checks](#checks), [Event Handlers](#handlers) and [Event Data Mutators](#mutators).

## Sensu Install (sensu-install) {#what-is-sensu-install}

The Sensu Core package provides a tool called `sensu-install`. The Sensu Install tool (`sensu-install`) simplifies Sensu Plugin installation. The `sensu-install` tool can be run with one or more arguments that determine the action(s) to take.

~~~ shell
$ sensu-install -h
Usage: sensu-install [options]
    -h, --help                       Display this message
    -v, --verbose                    Enable verbose logging
    -p, --plugin PLUGIN              Install a Sensu PLUGIN
    -P, --plugins PLUGIN[,PLUGIN]    PLUGIN or comma-delimited list of Sensu plugins to install
    -s, --source SOURCE              Install Sensu plugins from a custom SOURCE
~~~

_NOTE: `sensu-install` is only available in Sensu Core >= 0.21 (NEW)._

### Sensu Install example

The following instructions will install the [Sensu HTTP Plugin](https://github.com/sensu-plugins/sensu-plugins-http), using the Sensu Install tool (`sensu-install`).

#### Linux

~~~ shell
sudo sensu-install -p http:0.2.0
~~~

#### Windows

~~~ plain
C:\opt\sensu\bin\sensu-install.bat -p http:0.2.0
~~~

### Use a Sensu Plugin

After installing a Sensu Plugin (e.g. HTTP), its provided scripts can then be utilized by Sensu check, handler, and mutator definitions.

The following is an example Sensu check definition that uses the `check-http.rb` script provided by the [Sensu HTTP Plugin](https://github.com/sensu-plugins/sensu-plugins-http) ([as installed above](#sensu-install-example)).

~~~ json
{
  "checks": {
    "api_health": {
      "command": "check-http.rb -u https://api.example.com/health",
      "standalone": true,
      "interval": 60
    }
  }
}
~~~

### Sensu Plugin spec

Plugins provide scripts that output data to `STDOUT` or `STDERR` and produce an exit status code to indicate a state. The exit status codes used are `0` for `OK`, `1` for `WARNING`, `2` for `CRITICAL`, and `3` or greater to indicate `UNKNOWN` or `CUSTOM`.

The following is an example basic Sensu Plugin script.

~~~ ruby
#!/usr/bin/env ruby

# get the current list of processes
processes = `ps aux`

# determine if the chef-client process is running
running = processes.lines.detect do |process|
  process.include?('chef-client')
end

# return appropriate check output and exit status code
if running
  puts 'OK - Chef client process is running'
  exit 0
else
  puts 'WARNING - Chef client process is NOT running'
  exit 1
end
~~~