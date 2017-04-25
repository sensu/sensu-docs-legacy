---
title: "Mutators"
description: "Reference documentation for Sensu Mutators."
version: 0.29
weight: 7
---

# Sensu Mutators

## Reference documentation

- [What is a Sensu mutator?](#what-is-a-sensu-mutator)
  - [The Sensu mutator specification](#the-sensu-mutator-specification)
  - [When to use a mutator](#when-to-use-a-mutator)
- [How do Sensu mutators work?](#how-do-sensu-mutators-work)
- [Mutator commands](#mutator-commands)
  - [What is a mutator command?](#what-is-a-mutator-command)
  - [Mutator command arguments](#mutator-command-arguments)
  - [How and where are mutator commands executed?](#how-and-where-are-mutator-commands-executed)
- [Mutator configuration](#mutator-configuration)
  - [Example mutator definition](#example-mutator-definition)
  - [Mutator definition specification](#mutator-definition-specification)
    - [Mutator name(s)](#mutator-names)
    - [Mutator attributes](#mutator-attributes)

## What are Sensu mutators? {#what-are-sensu-mutators}

Sensu mutators are executable scripts or other programs that modify [event
data][1] for [Sensu event handlers][2] which may expect additional or modified
event data (e.g. custom attributes that are not provided by the default [event
data specification][3].

### The Sensu mutator specification

- Accept input/data via `STDIN`
- Able to parse a JSON data payload (i.e. a [event data][1])
- Output JSON data (the modified event data) to `STDOUT` or `STDERR`
- Produce an exit status code to indicate state:
  - `0` indicates OK
  - exit status codes other than `0` indicates a failure

### When to use a mutator

Many [Sensu event handlers][2] will modify [event data][1] in the course of
processing an [event][9], and in many cases this is recommended because
modifying the event data and performing some action in memory (in the same
process) will result in better performance than [executing a mutator][5] _and_ a
handler (two separate processes). However, when multiple handlers require
similar event data modifications, mutators provide the ability to avoid code
duplication (<abbr title="DON'T REPEAT YOURSELF!">DRY</abbr>), and simplify
event handler logic.

## How do Sensu mutators work?

Sensu mutators are applied when [event handlers][2] are configured to use a
`mutator`. Prior to executing a Handler, the Sensu server will execute the
configured `mutator`. If the mutator is successfully executed, the modified
event data is then provided to the handler and the handler will be executed. If
the mutator fails to execute for any reason, an error will be logged and the
handler will not be executed. The complete process may be described as follows:

- When the Sensu server is processing an event, it will check for the definition
  of a `mutator`. Prior to executing each handler, the Sensu server will first
  execute the configured `mutator` (if any) for the handler
- If the mutator is successfully executed (i.e. if it returns an exit status
  code of `0`), the modified event data is provided to the handler and the
  handler will be executed.
- If the mutator fails to execute (i.e. returns a non-zero exit status code, or
  does not complete execution within the configured `timeout`), an error will be
  logged and the handler will not be executed

Please refer to the [Sensu event handler definition specification][8] for more
information about applying a mutator to an event handler (see the `mutator`
attribute).

## Mutator commands

### What is a mutator command?

Each [Sensu mutator definition][6] defines a command to be executed. Mutator
commands are literally executable commands which will be executed on a [Sensu
server][4], run as the `sensu` user. Most mutator commands are provided by
[Sensu plugins][7].

### Mutator command arguments

Sensu mutator `command` attributes may include command line arguments for
controlling the behavior of the `command` executable. Many [Sensu mutator
plugins][7] provide support for command line arguments for reusability.

### How and where are mutator commands executed?

As mentioned above, all mutator commands are executed by a [Sensu server][4] as
the `sensu` user. Commands must be executable files that are discoverable on the
Sensu server system (i.e. installed in a system `$PATH` directory).

_NOTE: By default, the Sensu installer packages will modify the system `$PATH`
for the Sensu processes to include `/etc/sensu/plugins`. As a result, executable
scripts (e.g. plugins) located in `/etc/sensu/plugins` will be valid commands.
This allows `command` attributes to use "relative paths" for Sensu plugin
commands;<br><br>e.g.: `"command": "check-http.rb -u https://sensuapp.org"`_

## Mutator configuration

### Example mutator definition

The following is an example Sensu mutator definition, a JSON configuration file
located at `/etc/sensu/conf.d/example_mutator.json`. This mutator definition
uses an imaginary [Sensu plugin][7] called `example_mutator.rb` to modify event
data prior to handling the event.

~~~ json
{
  "mutators": {
    "example_mutator": {
      "command": "example_mutator.rb"
    }
  }
}
~~~

### Mutator definition specification

#### Mutator name(s)

Each mutator definition has a unique mutator name, used for the definition key.
Every mutator definition is within the `"mutators": {}` definition scope.

- A unique string used to name/identify the mutator
- Cannot contain special characters or spaces
- Validated with [Ruby regex][10] `/^[\w\.-]+$/.match("mutator-name")`

#### Mutator attributes

`command`
: description
  : The mutator command to be executed. The event data is passed to the process
    via `STDIN`.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "command": "/etc/sensu/plugins/mutated.rb"
    ~~~

`timeout`
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

[1]:  events.html#event-data
[2]:  handlers.html
[3]:  events.html#event-data-specification
[4]:  server.html
[5]:  #how-and-where-are-mutator-commands-executed
[6]:  #mutator-definition-specification
[7]:  plugins.html
[8]:  handlers.html#handler-definition-specification
[9]:  events.html
[10]: http://ruby-doc.org/core-2.2.0/Regexp.html
