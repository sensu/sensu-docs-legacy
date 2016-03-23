---
version: 0.22
category: "Reference Docs"
title: "The Sensu Client(s)"
next:
  url: "checks"
  text: "Checks"
---

# The Sensu Client

- [What are Sensu clients?](#what-are-sensu-clients)
- [Client keepalives](#client-keepalives)
  - [What is a client keepalive?](#what-is-a-client-keepalive)
  - [Client registration & the client registry](#registration-and-registry)
    - [Proxy clients](#proxy-clients)
  - [How are keepalive events created?](#keepalive-events)
  - [Client keepalive configuration](#client-keepalive-configuration)
- [Client subscriptions](#client-subscriptions)
  - [What is a client subscription?](#what-is-a-sensu-subscription)
  - [Round-robin client subscriptions](#round-robin-client-subscriptions)
  - [Client subscription configuration](#client-subscription-configuration)
- [Client socket input](#client-socket-input)
- [Client configuration](#client-configuration)
  - [Example client definition](#example-client-definition)
  - [Client definition attributes](#anatomy-of-a-client-definition)
    - [`client` attributes](#client-attributes)
    - [`socket` attributes](#socket-attributes)
    - [`keepalive` attributes](#keepalive-attributes)
    - [`thresholds` attributes](#thresholds-attributes)
  - [Custom client definition attributes](#custom-client-definition-attributes)

## What are Sensu clients? {#what-are-sensu-clients}

Sensu clients are [monitoring agents](architecture#monitoring-agent), which are
installaed and run on every system (e.g. server, container, etc) that needs to
be monitored. The client is responsible for registering the system with Sensu,
sending client [keepalive](#client-keepalives) messages (the Sensu heartbeat
mechanism), and executing monitoring checks. Each client is a member of one or
more [subscriptions](#client-subscriptions) &ndash; a list of roles and/or
responsibilities assigned to the system (e.g. a webserver, database, etc).
Sensu clients will "subscribe" to (or watch for) [check requests][requests]
published by the Sensu server (via the [Sensu Transport](transport)), execute
the corresponding requests locally, and publish the results of the check back to
the transport (to be processed by a Sensu server).

## Client keepalives

### What is a client keepalive?

Sensu Client `keepalives` are the heartbeat mechanism used by Sensu to ensure
that all registered Sensu clients are still operational and able to reach the
[Sensu Transport](transport). Sensu clients publish keepalive messages
containing client configuration data to the Sensu transport every 20 seconds (by
default). If a Sensu client fails to send keepalive messages over a period of
120 seconds (by default), the Sensu server (or Sensu Enterprise) will create a
keepalive [event](events). Keepalives can be used to identify unhealthy
machines and network partitions (among other things), and keepalive events can
trigger email notifications and other useful actions.

### Client registration & the client registry {#registration-and-registry}

In practice, client registrations happens when a Sensu server processes a client
`keepalive` message for a client that is not already registered in the Sensu
client registry (based on the configured client `name` or `source` attribute).
This client registry is stored in Redis, and is accessible via the Sensu
[Clients API](api-clients).

All Sensu client data provided in client keepalive messages gets stored in the
client registry, which data is used to add context to Sensu [Events](events) and
to detect Sensu clients in an unhealthy state.

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
documentation](api-clients).

### How are keepalive events created? {#keepalive-events}

Sensu servers (including Sensu Enterprise) monitor the Sensu client registry for
stale client data, detecting clients that have failed to send [client keepalive
messages](#what-is-a-client-keepalive) for more than 120 seconds (by default).
When a Sensu server detects that a client hasn't sent a keepalive message within
the configured `threshold`, _the Sensu server (or Sensu Enterprise)_ will create
an event (this is different from how events are created for monitoring checks;
see ["How are Sensu events created?"](events#how-are-events-created)).

### Client keepalive configuration

For more information on configuring client keepalives, please see the [client
keepalive attribute reference documentation](#keepalive-attributes) (below).

Sensu client keepalives are published to the Sensu transport every 20 seconds.
Client keepalive behavior can be configured per Sensu client, allowing each
Sensu client to set its own alert thresholds and keepalive event handlers. By
default, client data is considered stale if a keepalive hasn't be received in
`120` seconds (WARNING). By default, keepalive events will be sent to the Sensu
handler named `keepalive` if defined, or the `default` handler will be used.

To configure the keepalive check for a Sensu client, please refer to [the client
`keepalive` attributes reference documentation](#keepalive-attributes).

## Client subscriptions

### What is a client subscription?

Sensu's use of the pubsub pattern of communication allows for automated
registration & de-registration of ephemeral systems. At the core of this model
are Sensu client `subscriptions`.

Each Sensu client has a defined set of subscriptions, a list of roles and/or
responsibilities assigned to the system (e.g. a webserver,  database, etc).
These subscriptions determine which monitoring checks are  executed by the
client. Client subscriptions allow Sensu to request check  executions on a group
of machines at a time, instead of a traditional 1:1  mapping of configured hosts
to monitoring checks. Sensu checks target Sensu client subscriptions, using the
[check definition attribute `subscribers`](checks#definition-attributes).

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
client `subscriptions` attribute reference
documentation](#definition-attributes).

## Client configuration

The following is an example Sensu client definition, a JSON configuration file
located at `/etc/sensu/conf.d/client.json`. This client definition provides
Sensu with information about the machine on which it resides. This is a
production machine, running a web server and a MySQL database. The client 'name'
attribute is required in the definition, and must be unique.

### Example client definition

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

### Anatomy of a client definition

The client definition uses the `"client": {}` definition scope.

#### `client` attributes

name
: description
  : A unique name for the client. The name cannot contain special characters or spaces.
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
  : An address to help identify and reach the client. This is only informational, usually an IP address or hostname.
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
  : An array of client subscriptions, a list of roles/responsibilities that the machine has (e.g. webserver). These subscriptions determine which monitoring checks are executed by the client, as check requests are sent to subscriptions. The `subscriptions` array items must be strings.
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
  : If safe mode is enabled for the client. Safe mode requires local check definitions in order to accept a check request and execute the check.
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
  : Client definition attributes to redact (values) when logging and sending client keepalives.
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

#### `socket` attributes

The following attributes are configured within the `"socket": {}` client definition attribute scope.

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

The following attributes are configured within the `"keepalive": {}` client definition attribute scope.

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
  : An array of Sensu event handlers (names) to use for events created by keepalives. Each array item must be a string.
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
  : A set of attributes that configure the client keepalive "staleness" thresholds, when a client is determined to be unhealthy.
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
  : The warning threshold (in seconds) where a Sensu client is determined to be unhealthy, not having sent a keepalive in so many seconds.
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
  : The critical threshold (in seconds) where a Sensu client is determined to be unhealthy, not having sent a keepalive in so many seconds.
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

#### Keepalive custom attributes

Custom check definition attributes may also be included within the `keepalive`
scope. The custom attributes will be included in the keepalive check results,
which can be used by [event handlers](handlers), e.g. notification routing.

### Custom client definition attributes

Custom client definition attributes may be included to add additional
information about the Sensu client and the services that run on its machine.
Custom client attributes will be included in [event data](events) and can be
used with check command token substitution.

The following is an example Sensu client definition that has custom attributes for MySQL.

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
    "mysql": {
      "host": "127.0.0.1",
      "port": 3306,
      "user": "app",
      "password": "secret"
    }
  }
}
~~~

## Client socket input

Every Sensu client has a TCP & UDP socket listening for external check result input. The Sensu client socket(s) listen on `localhost` port `3030` by default and expect JSON formatted check results, allowing external sources (e.g. your web application, backup scripts, etc.) to push check results without needing to know anything about Sensu's internal implementation. An excellent client socket use case example is a web application pushing check results to indicate database connectivity issues.

To configure the Sensu client socket for a client, please refer to [the client socket attributes](#socket-attributes).

### Example external check result input

The following is an example demonstrating external check result input via the Sensu client TCP socket. The example uses Bash's built-in `/dev/tcp` file to communicate with the Sensu client socket.

~~~ shell
echo '{"name": "app_01", "output": "could not connect to mysql", "status": 1}' > /dev/tcp/localhost/3030
~~~

Netcat can also be used, instead of the TCP file:

~~~ shell
echo '{"name": "app_01", "output": "could not connect to mysql", "status": 1}' | nc localhost 3030
~~~

## Creating a "dead man's switch"

The Sensu client socket(s) in combination with check TTLs can be used to create what's commonly referred to as "dead man's switches". Outside of the software industry, a dead man's switch is a switch that is automatically triggered if a human operator becomes incapacitated (source: [Wikipedia](http://en.wikipedia.org/wiki/Dead_man%27s_switch)). Sensu is more interested in detecting silent failures than incapacited human operators. By using Check TTLs, Sensu is able to set an expectation that a Sensu client will continue to publish results for a check at a regular interval. If a Sensu client fails to publish a check result and the check TTL expires, Sensu will create an event to indicate the silent failure. For more information on check TTLs, please refer to [the check attributes reference documentation](checks#definition-attributes).

A great use case for the Sensu client socket is to create a dead man's switch for backup scripts, to ensure they continue to run successfully at regular intervals. If an external source sends a Sensu check result with a check TTL to the Sensu client socket, Sensu will expect another check result from the same external source before the TTL expires.

The following is an example of external check result input via the Sensu client TCP socket, using a check TTL to create a dead man's switch for MySQL backups. The example uses a check TTL of `25200` seconds (or 7 hours). A MySQL backup script using the following code would be expected to continue to send a check result at least once every 7 hours or Sensu will create an [event](events) to indicate the silent failure.

~~~ shell
echo '{"name": "backup_mysql", "ttl": 25200, "output": "backed up mysql successfully | size_mb=568", "status": 0}' | nc localhost 3030
~~~

~~~ shell
echo '{"name": "backup_mysql", "ttl": 25200, "output": "failed to backup mysql", "status": 1}' | nc localhost 3030
~~~

## Anatomy of a check result

name
: description
  : The check name used to identify it (context).
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "name": "db_nightly_backup"
    ~~~

output
: description
  : The check result output.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "output": "production db backup failed"
    ~~~

status
: description
  : The check result exit status to indicate severity.
: required
  : false
: type
  : Integer
: default
  : `0`
: example
  : ~~~ shell
    "status": 1
    ~~~

Check results can include standard [check definition attributes](checks) (e.g.
`handler`), as well as custom attributes to provide additional event context
and/or assist in alert routing etc.




[requests]:       checks#check-requests
