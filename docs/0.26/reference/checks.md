---
title: "Checks"
description: "Reference documentation for Sensu Checks."
version: 0.26
weight: 3
---

# Sensu Checks

## Reference documentation

- [What is a Sensu check?](#what-is-a-sensu-check)
  - [Sensu check specification](#sensu-check-specification)
- [Check commands](#check-commands)
  - [What is a check command?](#what-is-a-check-command)
  - [Check command arguments](#check-command-arguments)
  - [How and where are check commands executed?](#how-and-where-are-check-commands-executed)
- [Check execution platform](#check-execution-platform)
  - [How are checks scheduled?](#how-are-checks-scheduled)
    - [Subscription checks](#subscription-checks)
    - [Standalone checks](#standalone-checks)
- [Check results](#check-results)
  - [What is a check result?](#what-is-a-check-result)
  - [Example check result output](#example-check-result-output)
- [Check token substitution](#check-token-substitution)
  - [What is check token substitution?](#what-is-check-token-substitution)
  - [Example check tokens](#example-check-tokens)
  - [Check token specification](#check-token-specification)
    - [Token substitution syntax](#token-substitution-syntax)
    - [Token substitution default values](#token-substitution-default-values)
    - [Unmatched tokens](#unmatched-tokens)
- [Check configuration](#check-configuration)
  - [Example check definition](#example-check-definition)
  - [Check definition specification](#check-definition-specification)
    - [Check naming](#check-names)
    - [`CHECK` attributes](#check-attributes)
    - [`subdue` attributes](#subdue-attributes)
    - [Custom attributes](#custom-attributes)
  - [Check result specification](#check-result-specification)
    - [`check` attributes](#check-result-check-attributes)
    - [`client` attributes](#check-result-client-attributes)

## What is a Sensu check?

Sensu checks are commands executed by the [Sensu client][1] which monitor a
condition (e.g. is Nginx running?) or collect measurements (e.g. how much disk
space do I have left?). Although the Sensu client will attempt to execute any
command defined for a check, successful processing of check results requires
adherence to a simple specification.

### Sensu check specification

* Result data is output to [STDOUT or STDERR][2]
  * For standard checks this output is typically a human-readable message
  * For metrics checks this output contains the measurements gathered by the
    check
* Exit status code indicates state
  * `0` indicates "OK"
  * `1` indicates "WARNING"
  * `2` indicates "CRITICAL"
  * exit status codes other than `0`, `1`, or `2` indicate an "UNKNOWN" or
    custom status

_PRO TIP: Those familiar with the [Nagios][3] monitoring system may recognize
this specification, as it is the same one used by Nagios plugins. As a result,
Nagios plugins can be used with Sensu without any modification._

At every execution of a check command &ndash; regardless of success or failure
&ndash; the Sensu client publishes the check's [result][4] for eventual handling
by the [event processor][5] (i.e. the [Sensu server][6].

## Check commands

### What is a check command?

Each [Sensu check definition][7] defines a `command` and the interval at which
it  should be executed. Check commands are literally executable commands which
will be executed on the [Sensu client][1], run as the `sensu` user. Most check
commands are provided by [Sensu check plugins][8].

### Check command arguments

Sensu check `command` attributes may include command line arguments for
controlling the behavior of the command executable. Most [Sensu check
plugins][8] provide support for command line arguments for reusability.

### How and where are check commands executed?

As mentioned above, all check commands are executed by [Sensu clients][1] as the
`sensu` user. Commands must be executable files that are discoverable on the
Sensu client system (i.e. installed in a system [`$PATH` directory][9]).

_NOTE: By default, the Sensu installer packages will modify the system `$PATH`
for the Sensu processes to include `/etc/sensu/plugins`. As a result, executable
scripts (e.g. plugins) located in `/etc/sensu/plugins` will be valid commands.
This allows `command` attributes to use "relative paths" for Sensu plugin
commands; <br><br>e.g.: `"command": "check-http.rb -u https://sensuapp.org"`_

## Check execution platform

### How are checks scheduled?

Sensu offers two distinct check execution schedulers: the [Sensu
server](server), and the [Sensu client][10] (monitoring agent).
The Sensu server schedules and publishes check execution requests to client
subscriptions via a [Publish/Subscribe model][11] (i.e. [subscription
checks](#subscription-checks)). The Sensu client (monitoring agent) schedules and
executes [standalone checks][12] (on the local system only).
Because Sensu’s execution schedulers are not <abbr title="in other words, you
don't have to choose one or the other - you can use both">mutually
exclusive</abbr>, any Sensu client may be configured to both schedule and
execute it's own standalone checks as well as execute subscription checks
scheduled by the Sensu server.

#### Subscription checks

Sensu checks which are centrally defined and scheduled by the [Sensu server][6]
are called "subscription checks". Sensu’s use of a [message bus (transport)][13]
for communication enables [topic-based communication][14] &mdash; where messages
are published to a specific "topic", and consumers _subscribe_ to one or more
specific topics. This form of communication is commonly referred to as the
["publish-subscribe pattern"][11], or "pubsub" for short.

Subscription checks have a defined set of [subscribers][15], a list of
[transport][13] [topics][14] that check requests will be published to. Sensu
clients become subscribers to these topics (i.e. subscriptions) via their
individual [client definition][16] `subscriptions` attribute. In practice,
subscriptions will typically correspond to a specific role and/or responsibility
(e.g. a webserver, database, etc).

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

Sensu checks which are defined on a [Sensu client][1] with the [check definition
attribute][17] `standalone` set to `true` are called "standalone checks". The
Sensu client provides its own [scheduler][10] for scheduling standalone checks
which ensures <abbr title='typically within 500ms'>scheduling
consistency</abbr> between Sensu clients with identical check definitions
(assuming that system clocks are synchronized via [NTP][18]).

Standalone checks are an important complement to [subscription checks][19]
because they provide a de-centralized management alternative for Sensu.

## Check results

### What is a check result?

A check result is a [JSON][20] document published as a message on the [Sensu
transport][13] by the Sensu client upon completion of a check execution. Sensu
check results include the [check definition attributes][17] (e.g. `command`,
`subscribers`, `interval`, `name`, etc; including [custom attributes][21]), the
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

_NOTE: please refer to the [check result specification][38] (below) for more
information about check results._

## Check token substitution

### What is check token substitution?

Sensu [check definitions][17] may include attributes that you may wish to
override on a client-by-client basis. For example, [check commands][23] &ndash;
which may include [command line arguments][23] for controlling the behavior of
the check command &ndash; may benefit from client-specific thresholds, etc.
Sensu check tokens are check definition placeholders that will be replaced by
the Sensu client with the corresponding [client definition attribute][16] values
(including [custom attributes][24]).

_NOTE: Sensu check tokens were formerly known as "check command tokens"
(which limited token substitution to the check `command` attribute); command
tokens were also sometimes referred to as **"Sensu client overrides"**; a
reference to the fact that command tokens allowed client attributes to
"override" [check command arguments][23]._

_NOTE: Check tokens are processed before check execution, therefore token
substitution will not apply to check data delivered via the local [client
socket input][46]._

### Example check tokens

The following is an example Sensu [check definition][17] using three check
tokens for [check command arguments][23]. In this example, the
`check-disk-usage.rb` command accepts `-w` (warning) and `-c` (critical)
arguments to indicate the thresholds (as percentages) for creating warning or
critical events. As configured, this check will create a warning event at 80%
disk capacity, unless a different threshold is provided by the client definition
(i.e. `:::disk.warning|80:::`); and a critical event will be created if disk
capacity reaches 90%, unless a different threshold is provided by the client
definition (i.e. `:::disk.critical|90:::`). This example also creates a custom
check definition attribute called `environment`, which will default to a value
of `production`, unless a different value is provided by the client definition
(i.e. `:::environment|production:::`).

~~~ json
{
  "checks": {
    "check_disk_usage": {
      "command": "check-disk-usage.rb -w :::disk.warning|80::: -c :::disk.critical|90:::",
      "subscribers": [
        "production"
      ],
      "interval": 60,
      "environment": ":::environment|production:::"
    }
  }
}
~~~

The following example [Sensu client definition][16] would provide the necessary
attributes to override the `disk.warning`, `disk.critical`, and `environment`
tokens declared above.

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
    },
    "environment": "development"
  }
}
~~~

### Check token specification

#### Token substitution syntax

Check tokens are invoked by wrapping references to client attributes with
"triple colons" (i.e. three colon characters, i.e. `:::`). Nested Sensu [client
definition attributes][16] can be accessed via "dot notation" (e.g.
`disk.warning`).

- `:::address:::` would be replaced with the [client `address` attribute][26]
- `:::url:::` would be replaced with a [custom attribute][24] called `url`
- `:::disk.warning:::` would be replaced with a [custom attribute][24] called
  `warning` nested inside of a JSON hash called `disk`

#### Token substitution default values

Check token default values can be used as a fallback in the event that an
attribute is not provided by the [client definition][16]. Check token default
values are separated by a pipe character (`|`), and can be used to provide a
"fallback value" for clients that are missing the declared token attribute.

- `:::url|https://sensuapp.org:::` would be replaced with a [custom
  attribute][24] called `url`. If no such attribute called `url` is included in
  the client definition, the default (or fallback) value of
  `https://sensuapp.org` will be used.

#### Unmatched tokens

If a [token substitution default value][25] is not provided (i.e. as a fallback
value), _and_ the Sensu client definition does not have a matching definition
attribute, a [check result][4] indicating "unmatched tokens" will be published
for the check execution (e.g.: `"Unmatched check token(s): disk.warning"`).

## Check configuration

### Example check definition

The following is an example Sensu check definition, a JSON configuration file
located at `/etc/sensu/conf.d/check-sensu-website.json`. This check definition
uses a [Sensu plugin][27] named [`check-http.rb`][28] to ensure that the Sensu
website is still available. The check is named `sensu-website` and it runs on
Sensu clients with the `production` [subscription][15], at an `interval` of 60
seconds.

~~~ json
{
  "checks": {
    "sensu-website": {
      "command": "check-http.rb -u https://sensuapp.org",
      "subscribers": [
        "production"
      ],
      "interval": 60,
      "contact": "ops"
    }
  }
}
~~~

### Check definition specification

#### Check naming {#check-names}

Each check definition has a unique check name, used for the definition key.
Every check definition is within the `"checks": {}` [configuration scope][29].

- A unique string used to name/identify the check
- Cannot contain special characters or spaces
- Validated with [Ruby regex][30] `/^[\w\.-]+$/.match("check-name")`

#### `CHECK` attributes

The following attributes are configured within the `{"checks": { "CHECK": {} }
}` [configuration scope][29] (where `CHECK` is a valid [check name][41]).

`type`
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

`command`
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

`extension`
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

`standalone`
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

`subscribers`
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

`publish`
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

`interval`
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

`timeout`
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

`ttl`
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

`auto_resolve`
: description
  : When a check in a `WARNING` or `CRITICAL` state returns to an `OK` state,
    the event generated by the `WARNING` or `CRITICAL` state will be
    automatically resolved. Setting `auto_resolve` to `false` will prevent this
    automatic event resolution from occurring. This is useful in situations
    where you want to explicitly require manual resolution of an event, e.g. via
    the API or a dashboard.
: required
  : false
: type
  : Boolean
: default
  : true
: example
  : ~~~ shell
    "auto_resolve": false
    ~~~

`force_resolve`
: description
  : Setting `force_resolve` to `true` on a check result ensures that the event
  is resolved and removed from the registry, regardless of the current event
  action. This attribute is used internally by [Sensu's `/resolve` API][45].
: required
  : false
: type
  : Boolean
: default
  : false
: example
  : ~~~ shell
    "force_resolve": true
    ~~~

`handle`
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
    "handle": false
    ~~~

`handler`
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

`handlers`
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

`low_flap_threshold`
: description
  : The flap detection low threshold (% state change) for the check. Sensu uses
    the same [flap detection algorithm as Nagios][31].
: required
  : false
: type
  : Integer
: example
  : ~~~ shell
    "low_flap_threshold": 20
    ~~~

`high_flap_threshold`
: description
  : The flap detection high threshold (% state change) for the check. Sensu uses
    the same [flap detection algorithm as Nagios][31].
: required
  : true (if `low_flap_threshold` is configured)
: type
  : Integer
: example
  : ~~~ shell
    "high_flap_threshold": 60
    ~~~

`source`
: description
  : The check source, used to create a [JIT Sensu client][32] for an external
    resource (e.g. a network switch).
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

`aggregate`
: description
  : Create a named aggregate for the check. Check result data will be aggregated
    and exposed via the [Sensu Aggregates API][33].
    _NOTE: named aggregates are new to [Sensu version 0.24][43], now being
    defined with a String data type rather than a Boolean (i.e. `true` or
    `false`). Legacy check definitions with `"aggregate": true` attributes will
    default to using the check name as the aggregate name._
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "aggregate": "proxy_servers"
    ~~~

`aggregates`
: description
  : An array of strings defining one or more named aggregates (described above).
: required
  : false
: type
  : Array
: example
  : ~~~ shell
    "aggregates": [ "webservers", "production" ]
    ~~~

`subdue`
: description
  : The [`subdue` definition scope][42], used to determine when a check is
    subdued.
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "subdue": {}
    ~~~

`contact`
: description
  : A contact name to use for the check.
    **ENTERPRISE: This configuration is provided for using [Contact
    Routing][44].**
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "contact": "ops"
    ~~~

`contacts`
: description
  : An array of contact names to use for the check. Each array item (name) must
    be a string.
    **ENTERPRISE: This configuration is provided for using [Contact
    Routing][44].**
: required
  : false
: type
  : Array
: example
  : ~~~ shell
    "contacts": ["ops"]
    ~~~

#### `subdue` attributes

The following attributes are configured within the `{"checks": { "CHECK": {
"subdue": {} } } }` [configuration scope][29] (where `CHECK` is a valid [check
name][41]).

##### EXAMPLE {#subdue-attributes-example}

~~~ json
{
  "checks": {
    "check-printer": {
      "...": "...",
      "subdue": {
        "days": {
          "all": [
            {
              "begin": "5:00 PM",
              "end": "8:00 AM"
            }
          ]
        }
      }
    }
  }
}
~~~

##### ATTRIBUTES {#subdue-attributes-specification}

`days`
: description
  : A hash of days of the week or 'all', each day specified must
  define one or more time windows in which the check is not scheduled to
  be executed.
: required
  : false (unless `subdue` is configured)
: type
  : Hash
: example
  : ~~~ shell
    "days": {
      "all": [
        {
          "begin": "5:00 PM",
          "end": "8:00 AM"
        }
      ],
      "friday": [
        {
          "begin": "12:00 PM",
          "end": "5:00 PM"
        }
      ]
    }
    ~~~

#### Custom attributes

Because Sensu configuration is simply JSON data, it is possible to define
configuration attributes that are not part of the Sensu [check definition
specification][17]. These custom check attributes are included in
[check results][4] and [event data][40], providing additional context
about the check. Some great example use cases for custom check
definition attributes are links to playbook documentation
(i.e. "here's a link to some instructions for how to fix this if it's
broken"), [contact routing][36], and metric graph image URLs.

##### EXAMPLE

The following is an example Sensu check definition that a custom definition
attribute, `"playbook"`, a URL for documentation to aid in the resolution of
events for the check. The playbook URL will be available in [event data][34] and
thus able to be included in event notifications (e.g. email).

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

See [check results][4] (above) for more information about check results,
including an [example check result][37].

Required attributes below are the minimum for check results submitted
via the [client socket input][46]. Additional attributes are
automatically added by the client to build a complete check result.

#### `check` attributes {#check-result-check-attributes}

`status`
: description
  : The check execution exit status code. An exit status code of `0` (zero)
    indicates `OK`, `1` indicates `WARNING`, and `2` indicates `CRITICAL`; exit
    status codes other than `0`, `1`, or `2` indicate an `UNKNOWN` or custom
    status.
: required
  : true
: type
  : Integer
: example
  : ~~~ shell
    "status": 0
    ~~~

`command`
: description
  : The command as [provided by the check definition][17].
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "command": "check-http.rb -u https://sensuapp.org"
    ~~~

`subscribers`
: description
  : The check subscribers as [provided by the check definition][17].
: required
  : false
: type
  : Array
: example
  : ~~~ shell
    "subscribers": ["database_servers"]
    ~~~

`interval`
: description
  : The check interval in seconds, as [provided by the check definition][17]
: required
  : false
: type
  : Integer
: example
  : ~~~ shell
    "interval": 60
    ~~~

`name`
: description
  : The check name, as [provided by the check definition][17]
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "name": "sensu-website"
    ~~~

`issued`
: description
  : The time the check request was issued (by the [Sensu server][6] or
    [client][1]), stored as an integer (i.e. `Time.now.to_i`)
: required
  : false
: type
  : Integer
: example
  : ~~~ shell
    "issued": 1458934742
    ~~~

`executed`
: description
  : The time the check request was executed by the [Sensu client][1], stored as
    and integer (i.e. `Time.now.to_i`).
: required
  : false
: type
  : Integer
: example
  : ~~~ shell
    "executed": 1458934742
    ~~~

`duration`
: description
  : The amount of time (in seconds) it took for the [Sensu client][1] to execute
    the check.
: required
  : false
: type
  : Float
: example
  : ~~~ shell
    "duration": 0.637
    ~~~

`output`
: description
  : The output produced by the check `command`.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "output": "CheckHttp OK: 200, 78572 bytes\n"
    ~~~


#### `client` attributes {#check-result-client-attributes}

`name`
: description
  : The name of the [Sensu client][1] that generated the check result. The Sensu
    server will use the client `name` value to fetch the corresponding client
    attributes from the [Clients API][39] and add them to the resulting [Sensu
    event][34] for context.
: type
  : String
: example
  : ~~~ shell
    "output": "i-424242"
    ~~~


[?]:  #
[1]:  clients.html
[2]:  https://en.wikipedia.org/wiki/Standard_streams
[3]:  https://www.nagios.org/
[4]:  #check-results
[5]:  ../overview/architecture.html#event-processor
[6]:  server.html
[7]:  #check-configuration
[8]:  plugins.html#check-plugins
[9]:  https://en.wikipedia.org/wiki/PATH_(variable)
[10]: clients.html#standalone-check-execution-scheduler
[11]: https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern
[12]: #standalone-checks
[13]: transport.html
[14]: https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern#Message_filtering
[15]: clients.html#client-subscriptions
[16]: clients.html#client-definition-specification
[17]: #check-definition-specification
[18]: http://www.ntp.org/
[19]: #subscription-checks
[20]: http://www.json.org/
[21]: #custom-attributes
[22]: #check-commands
[23]: #check-command-arguments
[24]: clients.html#custom-attributes
[25]: #check-token-default-values
[26]: clients.html#client-attributes
[27]: plugins.html
[28]: https://github.com/sensu-plugins/sensu-plugins-http
[29]: configuration.html#configuration-scopes
[30]: http://ruby-doc.org/core-2.2.0/Regexp.html
[31]: https://assets.nagios.com/downloads/nagioscore/docs/nagioscore/3/en/flapping.html
[32]: clients.html#proxy-clients
[33]: ../api/aggregates-api.html
[34]: events.html
[35]: handlers.html
[36]: ../enterprise/contact-routing.html
[37]: #example-check-result-output
[38]: #check-result-specification
[39]: ../api/clients-api.html
[40]: events.html#event-data
[41]: #check-names
[42]: #subdue-attributes
[43]: /docs/0.24/overview/changelog.html
[44]: ../enterprise/contact-routing.html
[45]: ../api/events-api.html#the-resolve-api-endpoint
[46]: clients.html#client-socket-input
