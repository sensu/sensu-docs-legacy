---
version: 0.22
category: "Reference Docs"
title: "Sensu Client"
next:
  url: "checks"
  text: "Checks"
---

# Sensu Client

## Reference documentation

- [What is a Sensu client?](#what-is-a-sensu-client)
- [Client keepalives](#client-keepalives)
  - [What is a client keepalive?](#what-is-a-client-keepalive)
  - [Client registration & the client registry](#registration-and-registry)
    - [Registration events](#registration-events)
    - [Proxy clients](#proxy-clients)
  - [How are keepalive events created?](#keepalive-events)
  - [Client keepalive configuration](#client-keepalive-configuration)
- [Client subscriptions](#client-subscriptions)
  - [What is a client subscription?](#what-is-a-sensu-subscription)
  - [Round-robin client subscriptions](#round-robin-client-subscriptions)
  - [Client subscription configuration](#client-subscription-configuration)
- [Client socket input](#client-socket-input)
  - [What is the Sensu client socket](#what-is-the-sensu-client-socket)
  - [Example client socket usage](#example-client-socket-usage)
  - [Client socket configuration](#client-socket-configuration)
- [Standalone check execution scheduler](#standalone-check-execution-scheduler)
- [Client configuration](#client-configuration)
  - [Example client definition](#example-client-definition)
  - [Client definition specification](#client-definition-specification)
    - [`client` attributes](#client-attributes)
    - [`socket` attributes](#socket-attributes)
    - [`keepalive` attributes](#keepalive-attributes)
    - [`thresholds` attributes](#thresholds-attributes)
    - [`registration` attributes](#registration-attributes)
    - [Custom attributes](#custom-attributes)

## What is a Sensu client?

Sensu clients are [monitoring agents][1], which are installed and run on every
system (e.g. server, container, etc) that needs to be monitored. The client is
responsible for registering the system with Sensu, sending client [keepalive][2]
messages (the Sensu heartbeat mechanism), and executing monitoring checks. Each
client is a member of one or more [subscriptions][3] &ndash; a list of roles
and/or responsibilities assigned to the system (e.g. a webserver, database,
etc). Sensu clients will "subscribe" to (or watch for) [check requests][4]
published by the [Sensu server][5] (via the [Sensu Transport][6]), execute the
corresponding requests locally, and publish the results of the check back to the
transport (to be processed by a Sensu server).

## Client keepalives

### What is a client keepalive?

Sensu Client `keepalives` are the heartbeat mechanism used by Sensu to ensure
that all registered Sensu clients are still operational and able to reach the
[Sensu Transport][6]. Sensu clients publish keepalive messages containing client
configuration data to the Sensu transport every 20 seconds (by default). If a
Sensu client fails to send keepalive messages over a period of 120 seconds (by
default), the Sensu server (or Sensu Enterprise) will create a keepalive
[event][7]. Keepalives can be used to identify unhealthy systems and network
partitions (among other things), and keepalive events can trigger email
notifications and other useful actions.

### Client registration & the client registry {#registration-and-registry}

In practice, client registrations happens when a Sensu server processes a client
`keepalive` message for a client that is not already registered in the Sensu
client registry (based on the configured client `name` or `source` attribute).
This client registry is stored in the Sensu [data store][8], and is accessible
via the Sensu [Clients API][9].

All Sensu client data provided in client keepalive messages gets stored in the
client registry, which data is used to add context to Sensu [Events][7] and
to detect Sensu clients in an unhealthy state.

#### Registration events

_NOTE: registration events are new to [Sensu Core 0.22][33]._

If a [Sensu event handler][30] named `registration` is configured, or if a Sensu
client definition includes a [registration attribute][31], the [Sensu server][5]
will create and process a [Sensu event][7] for the client registration, applying
any configured [filters][26] and [mutators][32] before executing the configured
[handler(s)][30].

Registration events are useful for executing one-time handlers for new Sensu
clients. For example, registration event handlers can be used to update external
[Configuration Management Databases (CMDBs)][34] such as [ServiceNow][35], etc.

To configure a registration event handler, please refer to the [Sensu event
handler documentation][30] for instructions on creating a handler named
`registration`. Alternatively, please see [Client definition `registration`
attributes][31], below.

_WARNING: registration events are not stored in the event registry (in the Sensu
[data store][8]), so they are not accessible via the Sensu API; however, all
registration events are logged in the [Sensu server][5] log._

#### Proxy clients

Sensu proxy clients (formerly known as "Just-in-time" or "JIT" clients) are
dynamically created clients, added to the client registry if a client does not
already exist for a _check result_.

Proxy client registration differs from keepalive-based registration
because the registration event happens while processing a check result (not a
keepalive message). If a check result includes a `source` attribute, a proxy
client will be created for the `source`, and the check result will be stored
under the newly created client. Sensu proxy clients allow Sensu to monitor
external resources (e.g. on systems and/or devices where a `sensu-client` cannot
be installed, such a network switches), using the defined check `source` to
create a proxy clients for the external resource. Once created, proxy clients
work much in the same way as any other Sensu client; e.g. they are used to store
check execution history and provide context within event data.

_NOTE: `keepalive` monitoring is not supported for proxy clients, as they are
inherently unable to run a `sensu-client`._

By default, proxy client data includes a minimal number of attributes. The
following is an example of proxy client data that is added to the registry.

~~~ json
{
  "name": "switch-x",
  "address": "unknown",
  "subscriptions": [],
  "keepalives": false
}
~~~

The Sensu API can be used to update proxy client data in the client registry. To
update proxy client data, please refer to the [Client API reference
documentation][9].

### How are keepalive events created? {#keepalive-events}

Sensu servers (including Sensu Enterprise) monitor the Sensu client registry for
stale client data, detecting clients that have failed to send [client keepalive
messages][10] for more than 120 seconds (by default). When a Sensu server
detects that a client hasn't sent a keepalive message within the configured
`threshold`, _the Sensu server (or Sensu Enterprise)_ will create an event (this
is different from how events are created for monitoring checks; see ["How are
Sensu events created?"][11]).

### Client keepalive configuration

For more information on configuring client keepalives, please see the [client
keepalive attribute reference documentation][12] (below).

Sensu client keepalives are published to the Sensu transport every 20 seconds.
Client keepalive behavior can be configured per Sensu client, allowing each
Sensu client to set its own alert thresholds and keepalive event handlers. By
default, client data is considered stale if a keepalive hasn't be received in
`120` seconds (WARNING). By default, keepalive events will be sent to the Sensu
handler named `keepalive` if defined, or the `default` handler will be used.

To configure the keepalive check for a Sensu client, please refer to [the client
`keepalive` attributes reference documentation][12].

## Client subscriptions

### What is a client subscription?

Sensu's use of the [publish/subscribe pattern of communication][13] allows for
automated registration & de-registration of ephemeral systems. At the core of
this model are Sensu client `subscriptions`.

Each Sensu client has a defined set of subscriptions, a list of roles and/or
responsibilities assigned to the system (e.g. a webserver, database, etc). These
subscriptions determine which monitoring checks are executed by the client.
Client subscriptions allow Sensu to request check  executions on a group of
systems at a time, instead of a traditional 1:1  mapping of configured hosts to
monitoring checks. Sensu checks target Sensu client subscriptions, using the
[check definition attribute `subscribers`][14].

### Round-robin client subscriptions

Round-robin client subscriptions allow checks to be executed on a single client
within a subscription, in a round-robin fashion. To create a round-robin client
subscription, prepend the subscription name with `roundrobin:`, e.g.
`roundrobin:elasticsearch`. Any check that targets the
`roundrobin:elasticsearch` subscription will have its check requests sent to
clients in a round-robin fashion, meaning only one member (client) in the
subscription will execute a roundrobin check each time it is published.

The following is a Sensu client definition that includes a round-robin
subscription.

~~~ json
{
  "client": {
    "name": "i-424242",
    "address": "8.8.8.8",
    "subscriptions": [
      "production",
      "webserver",
      "roundrobin:webserver"
    ]
  }
}
~~~

The following is a Sensu check definition that targets a round-robin
subscription.

~~~ json
{
  "checks": {
    "web_application_api": {
      "command": "check-http.rb -u https://localhost:8080/api/v1/health",
      "subscribers": [
        "roundrobin:webserver"
      ],
      "interval": 20
    }
  }
}
~~~

### Client subscription configuration

To configure Sensu client subscriptions for a client, please refer to [the
client `subscriptions` attribute reference documentation][15].

## Client socket input

### What is the Sensu client socket?

Every Sensu client has a TCP & UDP socket listening for external check result
input. The Sensu client socket(s) listen on `localhost` port `3030` by default
and expect JSON formatted check results, allowing external sources (e.g. your
web application, backup scripts, etc.) to push check results without needing to
know anything about Sensu's internal implementation. An excellent client socket
use case example is a web application pushing check results to indicate database
connectivity issues.

To configure the Sensu client socket for a client, please refer to [the client
socket attributes][16].

### Example client socket usage

The following is an example demonstrating external check result input via the
Sensu client TCP socket. The example uses Bash's built-in `/dev/tcp` file to
communicate with the Sensu client socket.

~~~ shell
echo '{"name": "app_01", "output": "could not connect to mysql", "status": 1}' > /dev/tcp/localhost/3030
~~~

[Netcat][17] can also be used, instead of the TCP file:

~~~ shell
echo '{"name": "app_01", "output": "could not connect to mysql", "status": 1}' | nc localhost 3030
~~~

#### Creating a "dead man's switch"

The Sensu client socket(s) in combination with check TTLs can be used to create
what's commonly referred to as "dead man's switches". Outside of the software
industry, a dead man's switch is a switch that is automatically triggered if a
human operator becomes incapacitated (source: [Wikipedia][18]). Sensu is more
interested in detecting silent failures than incapacited human operators. By
using Check TTLs, Sensu is able to set an expectation that a Sensu client will
continue to publish results for a check at a regular interval. If a Sensu client
fails to publish a check result and the check TTL expires, Sensu will create an
event to indicate the silent failure. For more information on check TTLs, please
refer to [the check attributes reference documentation][14].

A great use case for the Sensu client socket is to create a dead man's switch
for backup scripts, to ensure they continue to run successfully at regular
intervals. If an external source sends a Sensu check result with a check TTL to
the Sensu client socket, Sensu will expect another check result from the same
external source before the TTL expires.

The following is an example of external check result input via the Sensu client
TCP socket, using a check TTL to create a dead man's switch for MySQL backups.
The example uses a check TTL of `25200` seconds (or 7 hours). A MySQL backup
script using the following code would be expected to continue to send a check
result at least once every 7 hours or Sensu will create an [event][7] to
indicate the silent failure.

~~~ shell
echo '{"name": "backup_mysql", "ttl": 25200, "output": "backed up mysql successfully | size_mb=568", "status": 0}' | nc localhost 3030
~~~

~~~ shell
echo '{"name": "backup_mysql", "ttl": 25200, "output": "failed to backup mysql", "status": 1}' | nc localhost 3030
~~~

## Standalone check execution scheduler

In addition to subscribing to [client subscriptions][3] and executing check
requests published by the [Sensu server][19], the Sensu client is able to
maintain its own/separate schedule for [standalone checks][20].

Because the Sensu client shares the same [check scheduling algorithm][21] as the
Sensu server, it is not only possible to have consistency between [subscription
checks][22] and standalone checks &mdash; it's also possible to maintain <abbr
title="typically accurate within 500ms">consistency</abbr> between standalone
checks _across an entire infrastructure_ (assuming that system clocks are
synchronized via [NTP][23]).

## Client configuration

### Example client definition

The following is an example Sensu client definition, a JSON configuration file
located at `/etc/sensu/conf.d/client.json`. This client definition provides
Sensu with information about the system on which it resides. This is a
production system, running a web server and a MySQL database. The client 'name'
attribute is required in the definition, and must be unique.

~~~ json
{
  "client": {
    "name": "i-424242",
    "address": "8.8.8.8",
    "subscriptions": [
      "production",
      "webserver",
      "mysql"
    ]
  }
}
~~~

### Client definition specification

The client definition uses the `"client": {}` [definition scope][24].

#### `client` attributes

name
: description
  : A unique name for the client. The name cannot contain special characters or
    spaces.
: required
  : true
: type
  : String
: validation
  : `/^[\w\.-]+$/`
: example
  : ~~~ shell
    "name": "i-424242"
    ~~~

address
: description
  : An address to help identify and reach the client. This is only
    informational, usually an IP address or hostname.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "address": "8.8.8.8"
    ~~~

subscriptions
: description
  : An array of client subscriptions, a list of roles and/or responsibilities
    assigned to the system (e.g. webserver). These subscriptions determine which
    monitoring checks are executed by the client, as check requests are sent to
    subscriptions. The `subscriptions` array items must be strings.
: required
  : true
: type
  : Array
: example
  : ~~~ shell
    "subscriptions": ["production", "webserver"]
    ~~~

safe_mode
: description
  : If safe mode is enabled for the client. Safe mode requires local check
    definitions in order to accept a check request and execute the check.
: required
  : false
: type
  : Boolean
: default
  : `false`
: example
  : ~~~ shell
    "safe_mode": true
    ~~~

redact
: description
  : Client definition attributes to redact (values) when logging and sending
    client keepalives.
: required
  : false
: type
  : Array
: default
  : ~~~ shell
    [
      "password", "passwd", "pass",
      "api_key", "api_token", "access_key",
      "secret_key", "private_key",
      "secret"
    ]
    ~~~
: example
  : ~~~ shell
    "redact": ["password", "ec2_access_key", "ec2_secret_key"]
    ~~~

socket
: description
  : A set of attributes that configure the Sensu client socket.
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "socket": {}
    ~~~

keepalive
: description
  : A set of attributes that configure the Sensu client keepalives.
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "keepalive": {}
    ~~~

registration
: description
  : A set of attributes for configuring Sensu registration event handlers.
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "registration": {}
    ~~~

#### `socket` attributes

The following attributes are configured within the `"socket": {}` client
definition attribute scope.

bind
: description
  : The address to bind the Sensu client socket to.
: required
  : false
: type
  : String
: default
  : `127.0.0.1`
: example
  : ~~~ shell
    "bind": "0.0.0.0"
    ~~~

port
: description
  : The port the Sensu client socket listens on.
: required
  : false
: type
  : Integer
: default
  : `3030`
: example
  : ~~~ shell
    "port": 3031
    ~~~

#### `keepalive` attributes

The following attributes are configured within the `"keepalive": {}` client
definition attribute scope.

handler
: description
  : The Sensu event handler (name) to use for events created by keepalives.
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
  : An array of Sensu event handlers (names) to use for events created by
    keepalives. Each array item must be a string.
: required
  : false
: type
  : Array
: example
  : ~~~ shell
    "handlers": ["pagerduty", "chef"]
    ~~~

thresholds
: description
  : A set of attributes that configure the client keepalive "staleness"
    thresholds, when a client is determined to be unhealthy.
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "thresholds": {}
    ~~~

#### `thresholds` attributes (for client keepalives) {#thresholds-attributes}

warning
: description
  : The warning threshold (in seconds) where a Sensu client is determined to be
    unhealthy, not having sent a keepalive in so many seconds.
: required
  : false
: type
  : Integer
: default
  : `120`
: example
  : ~~~ shell
    "warning": 60
    ~~~

critical
: description
  : The critical threshold (in seconds) where a Sensu client is determined to be
    unhealthy, not having sent a keepalive in so many seconds.
: required
  : false
: type
  : Integer
: default
  : `180`
: example
  : ~~~ shell
    "critical": 90
    ~~~

#### `registration` attributes

handler
: description
  : The registration handler that should process the client registration event.
: required
  : false
: type
  : String
: default
  : `registration`
: example
  : ~~~ shell
    "handler": "registration_cmdb"
    ~~~

_NOTE: client `registration` attributes are used to generate [check result][28]
data for the registration [event][7]. Client `registration` attributes are
merged with some default check definition attributes by the [Sensu server][5]
during client registration, so any [valid check definition attributes][14]
&ndash; including [custom check definition attributes][29] &ndash; may be used
as `registration` attributes. The following attributes are provided as
recommendations for controlling client registration behavior._

#### Custom attributes

Because Sensu configuration is just [JSON][25] data, it is possible to define
configuration attributes that are not part of the Sensu client specification.
Custom client definition attributes may be defined to provide context about the
Sensu client and the services that run on its system. Custom client attributes
will be included in client [keepalives][2], and [event data][7] and can be used
by Sensu [filters][26] (e.g. only alert on events in the "production"
environment), and accessed via [check command token substitution][27].

##### EXAMPLE

The following is an example Sensu client definition that has custom attributes
for the `environment` it is running in, a `mysql` attribute containing
information about a local database, and a link to an operational `playbook`.

~~~ json
{
  "client": {
    "name": "i-424242",
    "address": "10.0.2.101",
    "environment": "production",
    "subscriptions": [
      "production",
      "webserver",
      "mysql"
    ],
    "mysql": {
      "host": "10.0.2.101",
      "port": 3306,
      "user": "app",
      "password": "secret"
    },
    "playbook": "https://wiki.example.com/ops/mysql-playbook"
  }
}
~~~

_NOTE: Because client data is included in alerts created by Sensu, custom
attributes that only exist for the purpose of providing troubleshooting
information for operations teams can be extremely valuable._


[?]:  #
[1]:  architecture#monitoring-agent
[2]:  #client-keepalives
[3]:  #client-subscriptions
[4]:  checks#check-requests
[5]:  server
[6]:  transport
[7]:  events
[8]:  data-store
[9]:  api-clients
[10]: #what-is-a-client-keepalive
[11]: events#how-are-events-created
[12]: #keepalive-attributes
[13]: https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern
[14]: checks#definition-attributes
[15]: #definition-attributes
[16]: #socket-attributes
[17]: http://nc110.sourceforge.net/
[18]: http://en.wikipedia.org/wiki/Dead_man%27s_switch
[19]: server#check-execution-scheduling
[20]: checks#standalone-checks
[21]: server#check-scheduling-algorithm--synchronization
[22]: checks#subscription-checks
[23]: http://www.ntp.org/
[24]: configuration#configuration-scopes
[25]: http://www.json.org/
[26]: filters
[27]: checks#token-substitution
[28]: checks#check-results
[29]: checks#custom-attributes
[30]: handlers
[31]: #registration-attributes
[32]: mutators
[33]: changelog#v0-22-0
[34]: https://en.wikipedia.org/wiki/Configuration_management_database
[35]: http://www.servicenow.com/solutions/it-operations-management.html
