---
title: "Client"
description: "Reference documentation for Sensu Clients."
version: 0.25
weight: 2
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
    - [`deregistration` attributes](#deregistration-attributes)
    - [`ec2` attributes](#ec2-attributes)
    - [`chef` attributes](#chef-attributes)
    - [`puppet` attributes](#puppet-attributes)
    - [`servicenow` attributes](#servicenow-attributes)
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
configuration data to the Sensu transport every 20 seconds. If a Sensu client
fails to send keepalive messages over a period of 120 seconds (by default), the
Sensu server (or Sensu Enterprise) will create a keepalive [event][7].
Keepalives can be used to identify unhealthy systems and network partitions
(among other things), and keepalive events can trigger email notifications and
other useful actions.

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

##### Proxy client example

Proxy clients are created when a check result includes a `source` attribute, as
follows:

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
    "source": "sensuapp.org",
    "issued": 1458934742,
    "executed": 1458934742,
    "duration": 0.637,
    "output": "CheckHttp OK: 200, 78572 bytes\n"
  },
  "client": "sensu-docs"
}
~~~

_NOTE: this `source` attribute can be provided in a [check definition][14], or
included in a check result published to the Sensu [client input socket][36]._

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
    ],
    "socket": {
      "bind": "127.0.0.1",
      "port": 3030
    }
  }
}
~~~

### Client definition specification

The client definition uses the `{ "client": {} }` [configuration scope][24].

#### `client` attributes

`name`
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

`address`
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

`subscriptions`
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

`safe_mode`
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

`redact`
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
    "redact": [
      "password",
      "ec2_access_key",
      "ec2_secret_key"
    ]
    ~~~

`socket`
: description
  : The [`socket` definition scope][16], used to configure the [Sensu client
    socket][36].
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "socket": {}
    ~~~

`keepalives`
: description
  : If Sensu should monitor [keepalives][3] for this client.
: required
  : false
: default
  : `true`
: type
  : Boolean
: example
  : ~~~ shell
    "keepalives": false
    ~~~

`keepalive`
: description
  : The [`keepalive` definition scope][12], used to configure [Sensu client
    keepalives][2] behavior (e.g. keepalive thresholds, etc).
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "keepalive": {}
    ~~~

`registration`
: description
  : The [`registration` definition scope][31], used to configure [Sensu
    registration event][37] handlers.
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "registration": {}
    ~~~

`deregister`
: description
  : If a deregistration event should be created upon Sensu client process stop.
: required
  : false
: default
  : `false`
: example
  : ~~~ shell
    "deregister": true
    ~~~

`deregistration`
: description
  : The [`deregistration` definition scope][48], used to configure automated
    Sensu client de-registration.
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "deregistration": {}
    ~~~

`ec2`
: description
  : The [`ec2` definition scope][38], used to configure the [Sensu Enterprise
    AWS EC2 integration][39] ([Sensu Enterprise][40] users only).
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "ec2": {}
    ~~~

`chef`
: description
  : The [`chef` definition scope][41], used to configure the [Sensu Enterprise
    Chef integration][42] ([Sensu Enterprise][40] users only).
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "chef": {}
    ~~~

`puppet`
: description
  : The [`puppet` definition scope][43], used to configure the [Sensu Enterprise
    Puppet integration][44] ([Sensu Enterprise][40] users only).
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "puppet": {}
    ~~~

`servicenow`
: description
  : The [`servicenow` definition scope][45], used to configure the [Sensu
    Enterprise ServiceNow integration][46] ([Sensu Enterprise][40] users only).
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "servicenow": {}
    ~~~  

#### `socket` attributes

The following attributes are configured within the `{ "client": { "socket": {} }
}` [configuration scope][24].

##### EXAMPLE {#socket-attributes-example}

~~~ json
{
  "client": {
    "name": "1-424242",
    "...": "...",
    "socket": {
      "bind": "127.0.0.1",
      "port": 3030
    }
  }
}
~~~

##### ATTRIBUTES {#socket-attributes-specification}

`bind`
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

`port`
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

The following attributes are configured within the `{ "client": { "keepalive":
{} } }` [configuration scope][24].

##### EXAMPLE {#keepalive-attributes-example}

~~~ json
{
  "client": {
    "name": "1-424242",
    "...": "...",
    "keepalive": {
      "handler": "pagerduty",
      "thresholds": {
        "warning": 40,
        "critical": 60
      }
    }    
  }
}
~~~

##### ATTRIBUTES {#keepalive-attributes-specification}

`handler`
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

`handlers`
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

`thresholds`
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

The following attributes are configured within the `{ "client": { "keepalive": {
"thresholds": {} } } }` [configuration scope][24].

##### EXAMPLE {#thresholds-attributes-example}

~~~ json
{
  "client": {
    "name": "1-424242",
    "...": "...",
    "keepalive": {
      "...": "...",
      "thresholds": {
        "warning": 40,
        "critical": 60
      }
    }
  }
}
~~~

##### ATTRIBUTES {#thresholds-attributes-specification}

`warning`
: description
  : The warning threshold (in seconds) where a Sensu client is determined to be
    unhealthy, not having sent a keepalive in so many seconds.

    _WARNING: keepalive messages are sent at an interval of 20 seconds. Setting
    a `warning` threshold of 20 seconds or fewer will result in false-positive
    events. Also note that due to the potential for NTP synchronization issues
    and/or network latency or packet loss interfering with regular delivery of
    client keepalive messages, we recommend a minimum `warning` threshold of 40
    seconds._

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

`critical`
: description
  : The critical threshold (in seconds) where a Sensu client is determined to be
    unhealthy, not having sent a keepalive in so many seconds.

    _WARNING: keepalive messages are sent at an interval of 20 seconds. Setting
    a `critical` threshold of 20 seconds or fewer will result in false-positive
    events. Also note that due to the potential for NTP synchronization issues
    and/or network latency or packet loss interfering with regular delivery of
    client keepalive messages, we recommend a minimum `critical` threshold of 60
    seconds._

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

The following attributes are configured within the `{ "client": {
"registration": {} } }` [configuration scope][24].

##### EXAMPLE {#registration-attributes-example}

~~~ json
{
  "client": {
    "name": "1-424242",
    "...": "...",
    "registration": {
      "handler": "servicenow"
    }
  }
}
~~~

##### ATTRIBUTES {#registration-attributes-specification}

`handler`
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

#### `deregistration` attributes

The following attributes are configured within the `{ "client": {
"deregistration": {} } }` [configuration scope][24].

##### EXAMPLE {#deregistration-attributes-example}

~~~ json
{
  "client": {
    "name": "1-424242",
    "...": "...",
    "deregister": true,
    "deregistration": {
      "handler": "deregister_client"
    }
  }
}
~~~

##### ATTRIBUTES {#deregistration-attributes-specification}

_NOTE: client `deregistration` attributes are used to generate [check
result][28] data for the de-registration event. Client `deregistration`
attributes are merged with some default check definition attributes by the
[Sensu server][5] during client deregistration, so any [valid check definition
attributes][14] &ndash; including [custom check definition attributes][29]
&ndash; may be used as `deregistration` attributes, with the following
exceptions (which are used to ensure the check result is valid): check name,
`output`, `status`, and `issued` timestamp. The following attributes are
provided as recommendations for controlling client deregistration behavior._

`handler`
: description
  : The deregistration handler that should process the client deregistration
    event.
: required
  : false
: type
  : String
: default
  : `deregistration`
: example
  : ~~~ shell
    "handler": "cmdb_deregistration"
    ~~~

#### `ec2` attributes

The following attributes are configured within the `{ "client": { "ec2": {} }
}` [configuration scope][24].

**ENTERPRISE: This configuration is provided for using the built-in [Sensu
Enterprise AWS EC2 integration][39].**

##### EXAMPLE {#ec2-attributes-example}

~~~ json
{
  "client": {
    "name": "1-424242",
    "...": "...",
    "ec2": {
      "instance_id": "i-424242",
      "allowed_instance_states": [
        "running",
        "rebooting"
      ]
    }
  }
}
~~~

##### ATTRIBUTES {#ec2-attributes-specification}

`instance_id`
: description
  : The AWS EC2 instance ID of the Sensu client system (if different than the
    [client definition `name` attribute][15]), used to lookup instance status
    information with the AWS EC2 API.
: required
  : false
: type
  : String
: default
  : defaults to the value of the [client definition `name` attribute][15].
: example
  : ~~~ shell
    "instance_id": "i-424242"
    ~~~

`allowed_instance_states`
: description
  : The allowed operational states (e.g. `"running"`) for the instance. If a
    client keepalive event is created and the EC2 API indicates that the
    instance is _not_ in an allowed state (e.g. `"terminated"`), Sensu client
    will be removed from the [client registry][37]. This configuration can be
    provided to override the [built-in Sensu Enterprise `ec2` integration
    `allowed_instance_states` configuration][39] for the client.
: required
  : false
: type
  : Array
: allowed values
  : `pending`, `running`, `rebooting`, `stopping`, `stopped`, `shutting-down`,
    and `terminated`
: default
  : `running`
: example
  : ~~~ shell
    "allowed_instance_states": [
      "pending",
      "running",
      "rebooting"
    ]
    ~~~

`region`
: description
  : The AWS EC2 region to query for the EC2 instance state(s). This
    configuration can be provided to override the [built-in Sensu Enterprise
    `ec2` integration `region` configuration][39] for the client.
: required
  : false
: type
  : String
: allowed values
  :
: default
  : `us-east-1`
: example
  : ~~~ shell
    "region": "us-west-1"
    ~~~

`access_key_id`
: description
  : The AWS IAM user access key ID to use when querying the EC2 API. This
    configuration can be provided to override the [built-in Sensu Enterprise
    `ec2` integration `access_key_id` configuration][39] for the client.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "access_key_id": "AlygD0X6Z4Xr2m3gl70J"
    ~~~

`secret_access_key`
: description
  : The AWS IAM user secret access key to use when querying the EC2 API. This
    configuration can be provided to override the [built-in Sensu Enterprise
    `ec2` integration `secret_access_key` configuration][39] for the client.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "secret_access_key": "y9Jt5OqNOqdy5NCFjhcUsHMb6YqSbReLAJsy4d6obSZIWySv"
    ~~~

`timeout`
: description
  : The handler execution duration timeout in seconds (hard stop). This
    configuration can be provided to override the [built-in Sensu Enterprise
    `ec2` integration `timeout` configuration][39] for the client.
: required
  : false
: type
  : Integer
: default
  : `10`
: example
  : ~~~ shell
    "timeout": 30
    ~~~

#### `chef` attributes

The following attributes are configured within the `{ "client": { "chef": {} }
}` [configuration scope][24].

**ENTERPRISE: This configuration is provided for using the built-in [Sensu
Enterprise Chef integration][42].**

##### EXAMPLE {#chef-attributes-example}

~~~ json
{
  "client": {
    "name": "1-424242",
    "...": "...",
    "chef": {
      "node_name": "webserver01"
    }
  }
}
~~~

##### ATTRIBUTES {#chef-attributes-specification}

`node_name`
: description
  : The Chef node name (if different than the [client definition `name`
    attribute][15]), used to lookup node data in the Chef API.
: required
  : false
: type
  : String
: default
  : defaults to the value of the [client definition `name` attribute][15].
: example
  : ~~~ shell
    "node_name": "webserver01"
    ~~~

`endpoint`
: description
  : The Chef Server API endpoint (URL). This configuration can be provided to
    override the [built-in Sensu Enterprise `chef` integration `endpoint`
    configuration][42] for the client.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "endpoint": "https://api.chef.io/organizations/example"
    ~~~

`flavor`
: description
  : The Chef Server flavor (is it enterprise?). This configuration can be
    provided to override the [built-in Sensu Enterprise `chef` integration
    `flavor` configuration][42] for the client.
: required
  : false
: type
  : String
: allowed values
  : `enterprise`: for Hosted Chef and Enterprise Chef  
    `open_source`: for Chef Zero and Open Source Chef Server
: example
  : ~~~ shell
    "flavor": "enterprise"
    ~~~

`client`
: description
  : The Chef Client name to use when authenticating/querying the Chef Server
    API. This configuration can be provided to override the [built-in Sensu
    Enterprise `chef` integration `client` configuration][42] for the client.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "client": "sensu-server"
    ~~~

`key`
: description
  : The Chef Client key to use when authenticating/querying the Chef Server API.
    This configuration can be provided to override the [built-in Sensu
    Enterprise `chef` integration `key` configuration][42] for the client.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "key": "/etc/chef/i-424242.pem"
    ~~~

`ssl_pem_file`
: description
  : The Chef SSL pem file use when querying the Chef Server API. This
    configuration can be provided to override the [built-in Sensu Enterprise
    `chef` integration `ssl_pem_file` configuration][42] for the client.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "ssl_pem_file": "/etc/chef/ssl.pem"
    ~~~

`ssl_verify`
: description
  : If the SSL certificate will be verified when querying the Chef Server API.
    This configuration can be provided to override the [built-in Sensu
    Enterprise `chef` integration `ssl_verify` configuration][42] for the
    client.
: required
  : false
: type
  : Boolean
: default
  : `true`
: example
  : ~~~ shell
    "ssl_verify": false
    ~~~

`proxy_address`
: description
  : The HTTP proxy address. This configuration can be provided to override the
    [built-in Sensu Enterprise `chef` integration `proxy_address`
    configuration][42] for the client.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "proxy_address": "proxy.example.com"
    ~~~

`proxy_port`
: description
  : The HTTP proxy port (if there is a proxy). This configuration can be
    provided to override the [built-in Sensu Enterprise `chef` integration
    `proxy_port` configuration][42] for the client.
: required
  : false
: type
  : Integer
: example
  : ~~~ shell
    "proxy_port": 8080
    ~~~

`proxy_username`
: description
  : The HTTP proxy username (if there is a proxy). This configuration can be
    provided to override the [built-in Sensu Enterprise `chef` integration
    `proxy_username` configuration][42] for the client.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "proxy_username": "chef"
    ~~~

`proxy_password`
: description
  : The HTTP proxy user password (if there is a proxy). This configuration can
    be provided to override the [built-in Sensu Enterprise `chef` integration
    `proxy_password` configuration][42] for the client.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "proxy_password": "secret"
    ~~~

`timeout`
: description
  : The handler execution duration timeout in seconds (hard stop). This
    configuration can be provided to override the [built-in Sensu Enterprise
    `chef` integration `timeout` configuration][42] for the client.
: required
  : false
: type
  : Integer
: default
  : `10`
: example
  : ~~~ shell
    "timeout": 30
    ~~~

#### `puppet` attributes

The following attributes are configured within the `{ "client": { "puppet": {} }
}` [configuration scope][24].

**ENTERPRISE: This configuration is provided for using the built-in [Sensu
Enterprise Puppet integration][44].**

##### EXAMPLE {#puppet-attributes-example}

~~~ json
{
  "client": {
    "name": "1-424242",
    "...": "...",
    "puppet": {
      "node_name": "webserver01"
    }
  }
}
~~~

##### ATTRIBUTES {#puppet-attributes-specification}

`node_name`
: description
  : The Puppet node name (if different than the [client definition `name`
    attribute][15]), used to lookup node data in PuppetDB.
: required
  : false
: type
  : String
: default
  : defaults to the value of the [client definition `name` attribute][15].
: example
  : ~~~ shell
    "node_name": "webserver01"
    ~~~

#### `servicenow` attributes

The following attributes are configured within the `{ "client": { "servicenow":
{} } }` [configuration scope][24].

**ENTERPRISE: this configuration is provided for using the built-in [Sensu
Enterprise ServiceNow integration][46].**

##### EXAMPLE {#servicenow-attributes-example}

~~~ json
{
  "client": {
    "name": "1-424242",
    "...": "...",
    "servicenow": {
      "configuration_item": {
        "name": "webserver01"
      }
    }
  }
}
~~~

##### ATTRIBUTES {#servicenow-attributes-specification}

`configuration_item`
: description
  : The [ServiceNow Configuration Item definition scope][45] used to configure
    the ServiceNow CMDB Configuration Item for the client.
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "configuration_item": {
      "name": "webserver01"
    }
    ~~~

#### `configuration_item` attributes

The following attributes are configured within the `{ "client": { "servicenow":
{ "configuration_item": {} } } }` [configuration scope][24].

##### EXAMPLE {#configurationitem-attributes-example}

~~~ json
{
  "client": {
    "name": "1-424242",
    "...": "...",
    "servicenow": {
      "configuration_item": {
        "name": "webserver01",
        "os_version": "14.04"
      }
    }
  }
}
~~~

_PRO TIP: ServiceNow users may provide custom Configuration Item (CI) field values
via the `configuration_item` configuration scope. In this example, the CI field
`os_version` is being set to `14.04`._

##### ATTRIBUTES {#configurationitem-attributes-specification}

`name`
: description
  : The [ServiceNow Configuration Item name][47] to be used for the system.
: required
  : false
: type
  : String
: default
  : defaults to the value of the [client definition `name` attribute][15].
: example
  : ~~~ shell
    "name": "webserver01.example.com"
    ~~~

#### Custom attributes

Because Sensu configuration is just [JSON][25] data, it is possible to define
configuration attributes that are not part of the Sensu client specification.
Custom client definition attributes may be defined to provide context about the
Sensu client and the services that run on its system. Custom client attributes
will be included in client [keepalives][2], and [event data][7] and can be used
by Sensu [filters][26] (e.g. only alert on events in the "production"
environment), and accessed via [check token substitution][27].

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
[1]:  ../overview/architecture.html#monitoring-agent
[2]:  #client-keepalives
[3]:  #client-subscriptions
[4]:  checks.html#check-requests
[5]:  server.html
[6]:  transport.html
[7]:  events.html
[8]:  data-store.html
[9]:  ../api/clients-api.html
[10]: #what-is-a-client-keepalive
[11]: events.html#how-are-events-created
[12]: #keepalive-attributes
[13]: https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern
[14]: checks.html#check-definition-specification
[15]: #client-attributes
[16]: #socket-attributes
[17]: http://nc110.sourceforge.net/
[18]: http://en.wikipedia.org/wiki/Dead_man%27s_switch
[19]: server.html#check-execution-scheduling
[20]: checks.html#standalone-checks
[21]: server.html#check-scheduling-algorithm--synchronization
[22]: checks.html#subscription-checks
[23]: http://www.ntp.org/
[24]: configuration#configuration-scopes
[25]: http://www.json.org/
[26]: filters.html
[27]: checks.html#check-token-substitution
[28]: checks.html#check-results
[29]: checks.html#custom-attributes
[30]: handlers.html
[31]: #registration-attributes
[32]: mutators.html
[33]: changelog#v0-22-0
[34]: https://en.wikipedia.org/wiki/Configuration_management_database
[35]: http://www.servicenow.com/solutions/it-operations-management.html
[36]: #client-socket-input
[37]: #registration-and-registry
[38]: #ec2-attributes
[39]: ../enterprise/integrations/ec2.html
[40]: https://sensuapp.org/enterprise
[41]: #chef-attributes
[42]: ../enterprise/integrations/chef.html
[43]: #puppet-attributes
[44]: ../enterprise/integrations/puppet.html
[45]: #servicenow-attributes
[46]: ../enterprise/integrations/servicenow.html
[47]: http://wiki.servicenow.com/index.php?title=Introduction_to_Assets_and_Configuration
[48]: #deregistration-attributes
