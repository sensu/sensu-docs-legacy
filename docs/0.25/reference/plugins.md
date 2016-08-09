---
title: "Plugins"
description: "Reference documentation for Sensu Plugins."
version: 0.25
weight: 9
---

# Sensu Plugins

## Reference documentation

- [What is a Sensu plugin?](#what-is-a-sensu-plugin)
  - [The Sensu Plugin specification](#the-sensu-plugin-specification)
- [Where to find Sensu plugins](#where-to-find-sensu-plugins)
  - [The Sensu Plugins project](#the-sensu-plugins-project)
  - [Featured Sensu Plugins](#featured-sensu-plugins)
  - [Nagios plugins and the Nagios exchange](#nagios-plugins-and-the-nagios-exchange)
  - [Write you own custom plugins](#write-your-own-custom-plugins)
- [Plugin execution](#plugin-execution)
  - [How and where are plugins executed?](#how-and-where-are-mutator-commands-executed)
  - [What programming languages are supported?](#what-programming-languages-are-supported)
  - [What is Sensu's `EMBEDDED_RUBY`?](#what-is-sensus-embeddedruby)
- [Installing Sensu Plugins](#installing-sensu-plugins)
  - [Use `sensu-install` to install Sensu Plugins](#use-sensu-install-to-install-sensu-plugins)
  - [Alternative installation methods](#alternative-installation-methods)
- [The Sensu Plugin gem](#the-sensu-plugin-gem)
  - [What is the `sensu-plugin` gem?](#what-is-the-sensu-plugin-gem)
- [Plugin configuration](#plugin-configuration)
  - [Example check plugin definition](#example-check-plugin-definition)
  - [Sensu plugin definition specification](#sensu-plugin-definition-specification)

## What is a Sensu plugin?

Sensu plugins provide executable scripts or other programs that can be used as
[Sensu checks][1] (i.e. to monitor server resources, services, and application
health, or collect & analyze metrics), [Sensu handlers][2] (i.e. to send
notifications or perform other actions based on [Sensu events][3]), or [Sensu
mutators][3] (i.e. to modify [event data][4] prior to handling).

### The Sensu Plugin specification

Sensu Plugins provide executable scripts or other programs that can be used  as
a [Sensu check command][5], [pipe handler command][6], or [mutator  command][7].
Sensu plugins must comply with a simple specification:

- Accept input/data via `STDIN` (handler and mutator plugins only)
  - Optionally able to parse a JSON data payload (i.e. [event data][4])
- Output data to `STDOUT` or `STDERR`
- Produce an exit status code to indicate state:
  - `0` indicates `OK`
  - `1` indicates `WARNING`
  - `2` indicates `CRITICAL`
  - exit status codes other than `0`, `1`, or `2` indicate an unknown or custom
    status
- Optionally able to parse command line arguments to modify plugin behavior

_PRO TIP: Those familiar with the [Nagios][14] monitoring system may recognize
this specification, as it is the same one used by Nagios plugins. As a result,
[Nagios plugins can be used with Sensu][15] without any modification._

## Where to find Sensu Plugins

### The Sensu Plugins project

The [Sensu Plugins project][8] is a community-powered [open source software
project][9] that is organized by members of the Sensu community, in
collaboration with the Sensu development team. The Sensu Plugins project
currently maintains _hundreds_ of plugins providing various checks, handlers,
and mutators which are used by thousands of organizations around the world. Most
of the plugins maintained by the Sensu Plugins project are Ruby-based plugins
which are [distributed via Rubygems.org][10] (and [installable via
`sensu-install`][11]).

### Featured Sensu Plugins

To help new users discover some of the most popular plugins for instrumenting
their infrastructure and integrating Sensu with popular tools and services, a
[featured plugins page][12] is provided on the Sensu website. These featured
plugins are the same plugins developed and maintained by the [Sensu plugins
project][13].

### Nagios plugins and the Nagios Exchange

As previously mentioned, the [Sensu Plugin specification][16] is 100% compatible
with the [Nagios plugin specification][17]; as a result, **Nagios plugins may be
used with Sensu without any modification**. Sensu allows you to bring new life
to the 50+ plugins in the official [Nagios Plugins project][18] (which [began
life in 1999][19], making it a very mature source for monitoring plugins), and
over 4000 plugins available in the [Nagios Exchange][20].

### Write your own custom plugins

With a [simple specification][16], which makes it possible to [write Sensu
plugins in almost any programming language][21], it's very easy to write your
own custom plugins for Sensu.

#### Example plugins

The following example demonstrates how to write a very basic Sensu Plugin in the
Ruby programming language.

~~~ ruby
#!/usr/bin/env ruby
#
# A simple example handler plugin.

require 'json'

# Read the incoming JSON data from STDIN.
event = JSON.parse(STDIN.read, :symbolize_names => true)

# Create an output object using Ruby string interpolation
output = "The check named #{event[:check][:name]} generated the following output: #{event[:output]}"

# Convert the mutated event data back to JSON and output it to STDOUT.
puts output
~~~

_NOTE: this example doesn't provide much in terms of functionality (it would
simply be logged to the [Sensu server][23] log file), but it does provide a
starting point for a simple custom plugin._

## Plugin execution

### How and where are plugins executed?

As mentioned elsewhere in the documentation (see: [check commands][5], [pipe
handler commands][6], and [mutator commands][7]), all plugins are executed by a
[Sensu client][24] or [Sensu server][23] as the `sensu` user. Plugins must be
executable files that are discoverable on the Sensu system (i.e. installed in a
system `$PATH` directory), or they must be referenced with an absolute path
(e.g. `/opt/path/to/my/plugin`).

_NOTE: By default, the Sensu installer packages will modify the system `$PATH`
for the Sensu processes to include `/etc/sensu/plugins`. As a result, executable
scripts (e.g. plugins) located in `/etc/sensu/plugins` will be valid commands.
This allows command attributes to use "relative paths" for Sensu plugin
commands;<br><br>e.g.: `"command": "check-http.rb -u https://sensuapp.org"`_

### What programming languages are supported?

Any programming language that can satisfy the [Sensu plugin specification][16]
requirements &ndash; which is nearly any programming language in the world
&ndash; can be used to write Sensu plugins. One of the primary advantages of
writing Sensu plugins in the Ruby programming language is that Sensu itself is
written in Ruby, [and all Sensu installer packages provide an embedded
Ruby][25], eliminating the need to install or depend on a separate runtime.

_NOTE: plugins written in programming languages other than Ruby will require the
corresponding runtime to be installed in order for the plugin to run._

### What is Sensu's `EMBEDDED_RUBY`?

All Sensu Core installer packages provide an embedded Ruby runtime (i.e. even if
a system Ruby is installed, Sensu will run on its own Ruby). This "vendored"
Ruby runtime can be accessed by Ruby-based plugins by setting [Sensu's
`EMBEDDED_RUBY` configuration variable][26] to `true`.

_NOTE: in Sensu versions `>0.21.0`, all init/service scripts provided by the
Sensu Core installer packages are setting Sensu's `EMBEDDED_RUBY` environment
variable to `true`, making the use of Sensu's embedded Ruby the default behavior
in modern Sensu releases._

## Installing Sensu Plugins

### Use `sensu-install` to install Sensu Plugins

The Sensu Core package provides a tool called `sensu-install` (a simple wrapper
around the Ruby `gem` utility). The Sensu Install tool (`sensu-install`)
simplifies installation of Ruby-based plugins. The `sensu-install` tool can be
run with one or more arguments that determine the action(s) to take.

~~~ shell
$ sensu-install -h
Usage: sensu-install [options]
    -h, --help                       Display this message
    -v, --verbose                    Enable verbose logging
    -p, --plugin PLUGIN              Install a Sensu PLUGIN
    -P, --plugins PLUGIN[,PLUGIN]    PLUGIN or comma-delimited list of Sensu plugins to install
    -s, --source SOURCE              Install Sensu plugins from a custom SOURCE
~~~

_NOTE: `sensu-install` is only available in Sensu Core >= `0.21.0`._

#### EXAMPLE {#sensu-install-example}

The following instructions will install the [Sensu HTTP plugin][22], using the
`sensu-install` utility:

~~~ shell
$ sudo sensu-install -p nginx
[SENSU-INSTALL] installing Sensu plugins ...
[SENSU-INSTALL] determining if Sensu plugin gem 'sensu-plugins-nginx' is already installed ...
false
[SENSU-INSTALL] Sensu plugin gems to be installed: ["sensu-plugins-nginx"]
[SENSU-INSTALL] installing Sensu plugin gem 'sensu-plugins-nginx'
Fetching: sensu-plugins-nginx-1.0.0.gem (100%)
You can use the embedded Ruby by setting EMBEDDED_RUBY=true in /etc/default/sensu
Successfully installed sensu-plugins-nginx-1.0.0
1 gem installed
[SENSU-INSTALL] successfully installed Sensu plugins: ["nginx"]
~~~

To install a specific version of a plugin, simply provide a version number after
the plugin name (separated by a colon); for example:

~~~ shell
$ sudo sensu-install -p nginx:0.0.6
[SENSU-INSTALL] installing Sensu plugins ...
[SENSU-INSTALL] determining if Sensu plugin gem 'sensu-plugins-nginx:0.0.6' is already installed ...
false
[SENSU-INSTALL] Sensu plugin gems to be installed: ["sensu-plugins-nginx:0.0.6"]
[SENSU-INSTALL] installing Sensu plugin gem 'sensu-plugins-nginx:0.0.6'
Fetching: mixlib-cli-1.5.0.gem (100%)
Successfully installed mixlib-cli-1.5.0
Fetching: sensu-plugin-1.2.0.gem (100%)
Successfully installed sensu-plugin-1.2.0
Fetching: sensu-plugins-nginx-0.0.6.gem (100%)
You can use the embedded Ruby by setting EMBEDDED_RUBY=true in /etc/default/sensu
Successfully installed sensu-plugins-nginx-0.0.6
3 gems installed
[SENSU-INSTALL] successfully installed Sensu plugins: ["nginx:0.0.6"]
~~~

_NOTE: as shown in the examples above, the `sensu-install` utility will show the
output of any gems (including gem dependencies) installed using
`sensu-install`._

### Alternative installation methods

Coming soon...

## The Sensu Plugin gem

### What is the `sensu-plugin` gem?

Although Sensu Plugins [may be written in any programming language][21], there
are certain advantages of writing plugins in Ruby. From an operations
perspective, Ruby-based plugins are convenient because they are able to run on
[Sensu's embedded Ruby][25]. Ruby-based plugins also benefit from the
[`sensu-plugin` gem][27] &mdash; a Ruby library that provides some built-in
functionality and a number of helper classes and that simplify custom plugin
development.

Much of the built-in functionality provided by the `sensu-plugin` gem depends on
custom client, check, and/or handler definition attributes, as documented below.

## Plugin configuration

### Example check plugin definition

The following is an example [Sensu check definition][29] that uses the
`check-http.rb` script provided by the [Sensu HTTP Plugin][22], and a [custom
check definition attribute][28] called `refresh`. Although the `refresh`
attribute itself is not directly supported by Sensu, the `sensu-plugin` gem does
provide built-in support for reducing alert fatigue via the
`Sensu::Plugin::Handler` class (i.e. only handling events on the first
occurrence, and again every N occurrences, where N = `refresh`).

~~~ json
{
  "checks": {
    "api_health": {
      "command": "check-http.rb -u https://api.example.com/health",
      "standalone": true,
      "interval": 60,
      "refresh": 60
    }
  }
}
~~~

### Sensu plugin definition specification

_NOTE: plugins based on the `sensu-plugin` gem derive configuration from [custom
check definition attributes][28]. The configuration example(s) provided above,
and the "specification" provided here are for clarification and convenience only
(i.e. this "specification" is just an extension of the [check definition
specification][29], and not a definition of a distinct Sensu primitive)._

#### Check definition attributes

`occurrences`
: description
  : The number of event occurrences that must occur before an event is handled
    for the check.
  _NOTE: Sensu Enterprise users will need to define `occurrences` as part of
  `handle_when` configuration, see  [Built in Filters](enterprise-built-in-filters#the-handlewhen-filter)
  for more information._
: required
  : false
: type
  : Integer
: default
  : `1`
: example
  : ~~~ shell
    "occurrences": 3
    ~~~

`refresh`
: description
  : Time in seconds until the event occurrence count is considered reset for the
    purpose of counting `occurrences`, to allow an event for the check to be
    handled again. For example, a check with a refresh of `1800` will have its
    events (recurrences) handled every 30 minutes, to remind users of the issue.
    _NOTE: Sensu Enterprise users will need to define `refresh` as part of
    `handle_when` configuration, see  [Built in Filters](enterprise-built-in-filters#the-handlewhen-filter) for more information._
: required
  : false
: type
  : Integer
: default
  : `1800`
: example
  : ~~~ shell
    "refresh": 3600
    ~~~

`dependencies`
: description
  : An array of check dependencies. Events for the check will not be handled if
    events exist for one or more of the check dependencies. A check dependency
    can be a check executed by the same Sensu client (eg. `check_app`), or a
    client/check pair (eg.`db-01/check_mysql`).
: required
  : false
: type
  : Array
: example
  : ~~~ shell
    "dependencies": [
      "check_app",
      "db-01/check_mysql"
    ]
    ~~~

`notification`
: description
  : The notification message used for events created by the check, instead of
    the commonly used check output. This attribute is used by most notification
    event handlers that use the sensu-plugin library.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "notification": "the shopping cart application is not responding to requests"
    ~~~



[1]:  checks.html
[2]:  handlers.html
[3]:  events.html#event-data
[4]:  mutators.html
[5]:  checks.html#check-commands
[6]:  handlers.html#pipe-handler-commands
[7]:  mutators.html#mutator-commands
[8]:  http://sensu-plugins.io/
[9]:  https://github.com/sensu-plugins
[10]: https://rubygems.org/search?query=sensu-plugins-
[11]: #use-sensu-install-to-install-sensu-plugins
[12]: https://sensuapp.org/plugins
[13]: #the-sensu-plugins-project
[14]: https://www.nagios.org
[15]: #nagios-plugins-and-the-nagios-exchange
[16]: #the-sensu-plugin-specification
[17]: https://assets.nagios.com/downloads/nagioscore/docs/nagioscore/3/en/pluginapi.html
[18]: https://www.nagios.org/downloads/nagios-plugins/
[19]: https://www.nagios.org/about/history/
[20]: https://exchange.nagios.org/
[21]: #what-programming-languages-are-supported
[22]: https://github.com/sensu-plugins/sensu-plugins-http
[23]: server.html
[24]: clients.html
[25]: #what-is-sensus-embeddedruby
[26]: configuration.html#configuration-variables
[27]: https://github.com/sensu-plugins/sensu-plugin
[28]: checks.html#custom-attributes
[29]: checks.html#check-definition-attributes
