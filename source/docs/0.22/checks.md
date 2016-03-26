---
version: 0.22
category: "Reference Docs"
title: "Checks"
next:
  url: "handlers"
  text: "Handlers"
---

# Sensu Checks

## Reference Documentation

- [What is a Sensu check?](#what-is-a-sensu-check)
  - [Sensu check specification](#sensu-check-specification)
- [Check commands](#check-commands)
  - [What is a check command?](#what-is-a-check-command)
  - [How and where are check commands executed?](#how-and-where-are-check-commands-executed)
- [Check execution platform](#check-execution-platform)
  - [How are checks scheduled?](#how-are-checks-scheduled)
    - [Subscription checks](#subscription-checks)
    - [Standalone checks](#standalone-checks)
- [Check results](#check-results)
  - [What is a check result?](#what-is-a-check-result)
  - [Example check result output](#example-check-result-output)
- [Check command tokens](#check-command-tokens)
  - [What are check command tokens?](#what-are-check-command-tokens)
  - [Example check command tokens](#example-check-command-tokens)
  - [Check command token specification](#check-command-token-specification)
    - [Command token declaration syntax](#command-token-declaration)
    - [Command token client attributes](#command-token-client-attributes)
    - [Command token alternate values](#command-token-alternate-values)
- [Check definitions](#check-definitions)
  - [Example check definition](#example-check-definition)
  - [Check definition specification](#check-definition-specification)
    - [Check name(s)](#check-names)
    - [`check` attributes](#check-attributes)
    - [`subdue` attributes](#subdue-attributes)
    - [Custom attributes](#custom-attributes)
  - [Check result specification](#check-result-specification)
    - [`check` attributes](#check-result-check-attributes)
    - [`client` attributes](#check-result-client-attributes)

## What is a Sensu check?

Sensu checks define commands run by the [Sensu client](clients) which monitor a
condition (e.g. is Nginx running?) or read measurements (e.g. how much disk
space do I have left?). Although the Sensu client will attempt to execute any
command defined for a check, successful processing of check results requires
adherence to a simple specification.

### Sensu check specification

* Result data is output to [STDOUT or STDERR][std-streams]
  * For standard checks this output is typically a human-readable message
  * For metrics checks this output contains the measurements gathered by the
    check
* Exit status code indicates state
  * `0` indicates "OK"
  * `1` indicates "WARNING"
  * `2` indicates "CRITICAL"
  * exit status codes other than `0`, `1`, or `2` indicate an "UNKNOWN" or
    custom status

_PRO TIP: Those familiar with the [Nagios][nagios] monitoring system may recognize this
specification, as it is the same one used by Nagios plugins. As a result, Nagios
plugins can be used with Sensu without any modification._

At every execution of a check command &ndash; regardless of success or failure
&ndash; the Sensu client publishes the check's [result](#check-results) for
eventual handling by the [event processor](architecture#event-processor) (i.e.
the [Sensu server](server)).

## Check commands

### What is a check command?

Each [Sensu check definition](#check-definitions) defines a `command` and the
interval at which it  should be executed. Check commands are literally
executable commands which will be executed on the [Sensu client](clients),
run as the `sensu` user.

### Check command arguments



### How and where are check commands executed?

As mentioned above, all check commands are executed by [Sensu clients](clients)
as the `sensu` user. Commands must be executable files that are discoverable on
the Sensu client system (i.e. installed in a system [`$PATH` directory][path]).

_NOTE: By default, the Sensu installer packages will modify the system `$PATH` for the
`sensu` user to include `/etc/sensu/plugins`. As a result, executable scripts
(e.g. plugins) located in `/etc/sensu/plugins` will be valid commands. This
allows `command` attributes to use "relative paths" for Sensu plugin commands;
<br><br>e.g.: `"command": "check-http.rb -u https://sensuapp.org"`_

## Check execution platform

### How are checks scheduled?

Sensu offers two distinct check execution schedulers: the [Sensu
server](server), and the [Sensu client][client-scheduler] (monitoring agent).
The Sensu server schedules and publishes check execution requests to client
subscriptions via a [Publish/Subscribe model][pubsub] (i.e. [subscription
checks](#subscription-checks)). The Sensu client (monitoring agent) schedules and
executes [standalone checks](#standalone-checks) (on the local system only).
Because Sensu’s execution schedulers are not <abbr title="in other words, you
don't have to choose one or the other - you can use both">mutually
exclusive</abbr>, any Sensu client may be configured to both schedule and
execute it's own standalone checks as well as execute subscription checks
scheduled by the Sensu server.

#### Subscription checks

Sensu checks which are centrally defined and scheduled (i.e. by the [Sensu
server](server)) are called "subscription checks". Sensu’s use of a [message bus
(transport)](transport) for communication enables [topic-based
communication][pubsub-topics] &mdash; where messages are published to a specific
"topic", and consumers _subscribe_ to one or more specific topics. This form of
communication is commonly referred to as the ["publish-subscribe
pattern"][pubsub], or "pubsub" for short.

Subscription checks have a defined set of [subscribers][subscribers],
a list of [transport](transport) [topics][pubsub-topics] that check requests
will be published to. Sensu clients become subscribers to these topics (i.e.
subscriptions) via their individual [client definition][client-definitions]
`subscriptions` attribute. In practice, subscriptions will typically correspond
to a specific role and/or responsibility (e.g. a webserver, database, etc).

Subscriptions are a powerful primitives in the monitoring context because they
allow you to effectively monitor for specific behaviors or characteristics
corresponding to the function being provided by a particular system. For
example, disk capacity thresholds might be more important (or at least
different) on a database server as opposed to a webserver; conversely, CPU
and/or memory usage thresholds might be more important on a caching system than
on a file server. Subscriptions also allow you to configure check requests for
an entire group or subgroup of systems rather than require a traditional 1:1
mapping.

#### Standalone checks

Sensu checks which are defined on a [Sensu client](clients) with the [definition attribute](#check-definition-specification) `standalone` set to `true` are
called "standalone checks". The Sensu client provides its own
[scheduler](client-scheduler) for scheduling standalone checks which ensures
<abbr title='typically withing 500ms'>scheduling consistency</abbr> between
Sensu clients with identical check definitions (assuming that system clocks are
synchronized via [NTP][ntp]).

Standalone checks are an important complement to [subscription
checks](#subscription-checks) because they provide a de-centralized management
alternative for Sensu.

## Check results

### What is a check result?

A check result is a [JSON][json] document published as a message on the [Sensu
transport](transport) by the Sensu client upon completion of a check execution.
Sensu check results include the [check definition
attributes](#check-definition-specification) (e.g. `command`, `subscribers`,
`interval`, `name`, etc; including [custom attributes](#custom-attributes)), the
client name the result was submitted from, and the `output` of the check.

### Example check result output

~~~ json
{
  "check": {
    "status": 0,
    "command": "check-http.rb -u https://sensuapp.org",
    "subscribers": [
      "demo"
    ],
    "interval": 60,
    "name": "sensu-website",
    "issued": 1458934742,
    "executed": 1458934742,
    "duration": 0.637,
    "output": "CheckHttp OK: 200, 78572 bytes\n"
  },
  "client": "sensu-docs"
}
~~~

## Check command tokens

### What are check command tokens?

Sensu [check commands](#check-commands) may include [command line
arguments](#check-command-arguments) for controlling the behavior of the check
command (e.g. a [Sensu plugin](plugins)). Sensu check command arguments can be
used for configuring thresholds, file paths, URLs, and credentials. In some
cases, the check command arguments may need to differ on a clieny-by-client
basis in a Sensu [client subscription][subscribers]. Sensu check command tokens
are check command argument placeholders that can be replaced by [Sensu client
definition attributes][client-definitions] (including [custom check definition
attributes](clients#custom-attributes))).

_NOTE: as Sensu check command tokens are also sometimes referred to as **"Sensu
client overrides"**; a reference to the fact that command tokens allow client
attributes to "override" [check command arguments](#check-command-arguments)._

### Example check command tokens

The following is an example Sensu [check definition][check-spec], which is
using two check command tokens for [check command arguments][check-args]. In
this example, the `check-disk-usage.rb` command accepts `-w` (warning) and `-c`
(critical) arguments to indicate the thresholds (as percentages) for creating
warning or critical events. As configured, this check will create a warning
event at 80% disk capacity, unless a different threshold is provided by the
client definition (i.e. `:::disk.warning|80:::`); and a critical event will be
created if disk capacity reaches 90%, unless a different threshold is provided
by the client definition (i.e. `:::disk.critical|90:::`).

~~~ json
{
  "checks": {
    "check_disk_usage": {
      "command": "check-disk-usage.rb -w :::disk.warning|80::: -c :::disk.critical|90:::",
      "subscribers": [
        "production"
      ],
      "interval": 60
    }
  }
}
~~~

The following example [Sensu client definition][client-definitions] would
provide the necessary attributes to override the `disk.warning` and
`disk.critical` tokens declared above.

~~~ json
{
  "client": {
    "name": "i-424242",
    "address": "10.0.2.100",
    "subscriptions": [
      "production",
      "webserver",
      "mysql"
    ],
    "disk": {
      "warning": 75,
      "critical": 85
    }
  }
}
~~~

### Check command token specification

Sensu check command tokens provide access to [Sensu client definition
attributes][client-definitions] via "dot notation" (e.g. `disk.warning`).

#### Command token declaration syntax

Command tokens are declared by wrapping [client
attributes](#command-token-client-attributes) with "triple colons" (i.e. three
colon characters, i.e. `:::`).

##### Examples {#command-token-declaration-examples}

- `:::address:::` would be replaced with the [client `address`
  attribute](clients#client-attributes)
- `:::url:::` would be replaced with a [custom
  attribute](clients#custom-attributes) called `url`

#### Command token client attributes

Command token attributes are "dot notation" references to [Sensu client
definition attributes][client-definitions].

##### Examples {#command-token-client-attributes-examples}

- `:::address:::` would be replaced with the [client `address`
  attribute](clients#client-attributes)
- `:::disk.warning:::` would be replaced with a [custom
  attribute](clients#custom-attributes) called `warning` nested inside of a JSON
  hash called `disk`

#### Command token alternate values

Command token alternate values can be used as a fallback in the event that no
a [command token client attribute](#command-token-client-attribute) is not
provided by the [client definition][client-definitions]. Command token alternate
values are separated by a pipe character (`|`), and can be used to provide a
"default values" for clients that are missing the declared token attribute.

##### Examples {#command-token-alternate-values}

- `:::url|https://sensuapp.org:::` would be replaced with a [custom
  attribute](clients#custom-attributes) called `url`. If no such attribute
  called `url` is included in the client definition, the alternate (or default)
  value of `https://sensuapp.org` will be used.

_NOTE: if a command token alternate value is not provided (i.e. as a default
value), and the Sensu client definition does not have a matching [command token
client attribute](#command-token-client-attribute), a [check
result](#check-results) indicating unmatched tokens will be published for the
check execution (e.g.: `"Unmatched command tokens: disk.warning"`)_

## Check definitions

A Sensu check definition is a JSON configuration file describing a Sensu check.
A definition declares how a Sensu check is executed:

- The command to run (e.g. script)
- How frequently it should be executed (interval)
- Where it should be executed (which machines)

### Example check definition

The following is an example Sensu check definition, a JSON configuration file
located at `/etc/sensu/conf.d/check_chef_client.json`. This check definition
uses the [example check plugin](#example-check-plugin) above, to determine if
the Chef client process is running. The check is named `chef_client` and it runs
`/etc/sensu/plugins/check-chef-client.rb` on Sensu clients with the `production`
subscription, every `60` seconds (interval).

~~~ json
{
  "checks": {
    "chef_client": {
      "command": "/etc/sensu/plugins/check-chef-client.rb",
      "subscribers": [
        "production"
      ],
      "interval": 60
    }
  }
}
~~~

### Check definition specification

#### Check names(s) {#check-names}

Each check definition has a unique check name, used for the definition key.
Every check definition is within the `"checks": {}` definition scope.

- A unique string used to name/identify the check
- Cannot contain special characters or spaces
- Validated with `/^[\w\.-]+$/`
- e.g. `"chef_client": {}`

#### `check` attributes

type
: description
  : The check type, either `standard` or `metric`. Setting type to `metric` will
    cause OK (exit 0) check results to create events.
: required
  : false
: type
  : String
: allowed values
  : `standard`, `metric`
: default
  : `standard`
: example
  : ~~~ shell
    "type": "metric"
    ~~~

command
: description
  : The check command to be executed.
: required
  : true (unless `extension` is configured)
: type
  : String
: example
  : ~~~ shell
    "command": "/etc/sensu/plugins/check-chef-client.rb"
    ~~~

extension
: description
  : The name of a Sensu check extension to run instead of a command. This is an
    _advanced feature_ and is not commonly used.
: required
  : true (unless `command` is configured)
: type
  : String
: example
  : ~~~ shell
    "extension": "system_profile"
    ~~~

standalone
: description
  : If the check is scheduled by the local Sensu client instead of the Sensu
    server (standalone mode).
: required
  : false
: type
  : Boolean
: default
  : false
: example
  : ~~~ shell
    "standalone": true
    ~~~

subscribers
: description
  : An array of Sensu client subscriptions that check requests will be sent to.
    The array cannot be empty and its items must each be a string.
: required
  : true (unless `standalone` is `true`)
: type
  : Array
: example
  : ~~~ shell
    "subscribers": ["production"]
    ~~~

publish
: description
  : If check requests are published for the check.
: required
  : false
: type
  : Boolean
: default
  : true
: example
  : ~~~ shell
    "publish": false
    ~~~

interval
: description
  : The frequency in seconds the check is executed.
: required
  : true (unless `publish` is `false`)
: type
  : Integer
: example
  : ~~~ shell
    "interval": 60
    ~~~

timeout
: description
  : The check execution duration timeout in seconds (hard stop).
: required
  : false
: type
  : Integer
: example
  : ~~~ shell
    "timeout": 30
    ~~~

ttl
: description
  : The time to live (TTL) in seconds until check results are considered stale.
    If a client stops publishing results for the check, and the TTL expires, an
    event will be created for the client. The check `ttl` must be greater than
    the check `interval`, and should accommodate time for the check execution and
    result processing to complete. For example, if a check has an `interval` of
    `60` (seconds) and a `timeout` of `30` (seconds), an appropriate `ttl` would
    be a minimum of `90` (seconds).
: required
  : false
: type
  : Integer
: example
  : ~~~ shell
    "ttl": 100
    ~~~

handle
: description
  : If events created by the check should be handled.
: required
  : false
: type
  : Boolean
: default
  : true
: example
  : ~~~ shell
    "handle": "false"
    ~~~

handler
: description
  : The Sensu event handler (name) to use for events created by the check.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "handler": "pagerduty"
    ~~~

handlers
: description
  : An array of Sensu event handlers (names) to use for events created by the
    check. Each array item must be a string.
: required
  : false
: type
  : Array
: example
  : ~~~ shell
    "handlers": ["pagerduty", "email"]
    ~~~

low_flap_threshold
: description
  : The flap detection low threshold (% state change) for the check. Sensu uses
    the same [flap detection algorithm as Nagios][nagios-flapping].
: required
  : false
: type
  : Integer
: example
  : ~~~ shell
    "low_flap_threshold": 20
    ~~~

high_flap_threshold
: description
  : The flap detection high threshold (% state change) for the check. Sensu uses
    the same [flap detection algorithm as Nagios][nagios-flapping].
: required
  : true (if `low_flap_threshold` is configured)
: type
  : Integer
: example
  : ~~~ shell
    "high_flap_threshold": 60
    ~~~

source
: description
  : The check source, used to create a [JIT Sensu client](clients#proxy-clients)
    for an external resource (e.g. a network switch).
: required
  : false
: type
  : String
: validated
  : `/^[\w\.-]+$/`
: example
  : ~~~ shell
    "source": "switch-dc-01"
    ~~~

aggregate
: description
  : Create a result aggregate for the check. Check result data will be
    aggregated and exposed via the [Sensu Aggregates API](api-aggregates). This
    feature does not work with `standalone` checks.
: required
  : false
: type
  : Boolean
: default
  : false
: example
  : ~~~ shell
    "aggregate": true
    ~~~

subdue
: description
  : A set of attributes that determine when a check is subdued.
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "subdue": {}
    ~~~

#### `subdue` attributes

The following attributes are configured within the `"subdue": {}` check
definition attribute scope.

at
: description
  : Where the check is subdued, either `publisher` or `handler`, at the check
    request publisher or event handler.
: required
  : false
: type
  : String
: allowed values
  : `publisher`, `handler`
: example
  : ~~~ shell
    "at": "handler"
    ~~~

days
: description
  : An array of days of the week the check is subdued. Each array item must be a
    string and a valid day of the week.
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
  : Beginning of the time window when the check is subdued. Parsed by Ruby's
    `Time.parse()`. Time may include a time zone.
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
  : End of the time window when the check is subdued. Parsed by Ruby's
    `Time.parse()`. Time may include a time zone.
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
  : Subdue time window (`begin`, `end`) exceptions. An array of time window
    exceptions. Each array item must be a hash containing valid `begin` and
    `end` times.
: required
  : false
: type
  : Array
: example
  : ~~~ shell
    "exceptions": [{"begin": "8PM PST", "end": "10PM PST"}]
    ~~~

#### Custom attributes

Custom check definition attributes may be included to add additional information
(context) about the Sensu check. Custom check attributes will be included in
[event data](events). Some great example use cases for custom check definition
attributes are contact routing, documentation links, and metric graph image
URLs.

The following is an example Sensu check definition that a custom definition
attribute, `"playbook"`, a URL for documentation to aid in the resolution of
events for the check. The playbook URL will be available in [event data](events)
and thus able to be included in event notifications (e.g. email).

~~~ json
{
  "checks": {
    "check_mysql_replication": {
      "command": "check-mysql-replication-status.rb --user sensu --password secret",
      "subscribers": [
        "mysql"
      ],
      "interval": 30,
      "playbook": "http://docs.example.com/wiki/mysql-replication-playbook"
    }
  }
}
~~~

### Check result specification

#### `check` attributes {#check-result-check-attributes}

#### `client` attributes {#check-result-client-attributes}



[nagios-flapping]:        https://assets.nagios.com/downloads/nagioscore/docs/nagioscore/3/en/flapping.html
[handle_when]:            enterprise-built-in-filters#the-handlewhen-filter
[std-streams]:            https://en.wikipedia.org/wiki/Standard_streams
[nagios]:                 https://www.nagios.org/
[client-scheduler]:       clients#standalone-check-execution-scheduler
[pubsub]:                 https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern
[pubsub-topics]:          https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern#Message_filtering
[subscribers]:            clients#client-subscriptions
[client-definitions]:     clients#client-definition-specification
[path]:                   https://en.wikipedia.org/wiki/PATH_(variable)
[json]:                   http://www.json.org/
[ntp]:                    http://www.ntp.org/
[check-spec]:             #check-defintiion-specification
[check-args]:             #check-command-arguments
