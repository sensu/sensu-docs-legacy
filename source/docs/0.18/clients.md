---
version: 0.18
category: "Reference Docs"
title: "Clients"
next:
  url: "checks"
  text: "checks"
---

# Overview

This reference document provides information to help you:

- Understand what a Sensu client is
- Understand what a Sensu client does
- Write a Sensu client definition
- Manage the Sensu client process on Linux
- Manage the Sensu client process on Windows

# What are Sensu clients? {#what-are-sensu-clients}

Sensu clients are monitoring agents, running on every machine that needs to be monitored. The client is responsible for registering the machine with Sensu and executing monitoring checks. Each client has a set of subscriptions, a list of roles/responsibilities the machine has (e.g. webserver), these subscriptions determine which monitoring checks are executed. The Sensu client publishes every check execution result to the message bus to be processed elsewhere. Sensu clients publish keepalives every 20 seconds, to help detect machines in an unhealthy state. Client keepalives contain the local client definition, to update the client registry, and provide additional context in event data.

# Client definition

The following is an example Sensu client definition, a JSON configuration file located at `/etc/sensu/conf.d/client.json`. This client definition provides Sensu with information about the machine on which it resides. This is a production machine, running a web server and a database.

## Example client definition

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

# Anatomy of a client definition

The client definition uses the `"client": {}` definition scope.

### Definition attributes

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
  : An array of client subscriptions that check requests will be sent to. The array cannot be empty and its items must each be a string.
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

#### Socket attributes

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

#### Keepalive attributes

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

#### Keepalive thresholds attributes

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

Custom check definition attributes may also be included within the `keepalive` scope. The custom attributes will be included in the keepalive check results, which can be used by [event handlers](handlers), e.g. notification routing.

# Manage the client process on Linux

The Sensu client process `sensu-client` is managed with an init script included in the Sensu Core package. The Sensu client init script is able to start/stop/restart the local process.

~~~ shell
sudo /etc/init.d/sensu-client start
sudo /etc/init.d/sensu-client stop
sudo /etc/init.d/sensu-client restart
~~~

## Init script configuration

The init script loads/sources several platform specific configuration files before managing the process.

### Ubuntu/Debian

`/etc/default/sensu` and `/etc/default/sensu-client`

### CentOS/RHEL

`/etc/default/sensu` and `/etc/sysconfig/sensu-client`

### Configuration variables

The following configuration options (variables) can be set in the init configuration files for the platform.

EMBEDDED_RUBY
: description
  : If the Sensu embedded Ruby runtime is used for check executions, adding Ruby to Sensu's `$PATH`.
: required
  : false
: default
  : `false`
: example
  : ~~~ shell
    EMBEDDED_RUBY=true
    ~~~

CONFIG_FILE
: description
  : The primary configuration file path.
: required
  : false
: default
  : `/etc/sensu/config.json`
: example
  : ~~~ shell
    CONFIG_FILE=/etc/sensu/config.json
    ~~~

CONFIG_DIR
: description
  : The configuration snippet directory path.
: required
  : false
: default
  : `/etc/sensu/conf.d`
: example
  : ~~~ shell
    CONFIG_DIR=/etc/sensu/conf.d
    ~~~

EXTENSION_DIR
: description
  : The Sensu extension directory path.
: required
  : false
: default
  : `/etc/sensu/extensions`
: example
  : ~~~ shell
    EXTENSION_DIR=/etc/sensu/extensions
    ~~~

PLUGINS_DIR
: description
  : The Sensu plugins directory path, to add to the Sensu's `$PATH`.
: required
  : false
: default
  : `/etc/sensu/plugins`
: example
  : ~~~ shell
    PLUGINS_DIR=/etc/sensu/plugins
    ~~~

HANDLERS_DIR
: description
  : The Sensu handlers directory path, to add to Sensu's `$PATH`. This is only used by the Sensu server.
: required
  : false
: default
  : `/etc/sensu/handlers`
: example
  : ~~~ shell
    HANDLERS_DIR=/etc/sensu/handlers
    ~~~

LOG_DIR
: description
  : The log file directory path.
: required
  : false
: default
  : `/var/log/sensu`
: example
  : ~~~ shell
    LOG_DIR=/var/log/sensu
    ~~~

LOG_LEVEL
: description
  : The log level to default the logger to.
: required
  : false
: default
  : `info`
: allowed values
  : `debug`, `info`, `warn`, `error`, `fatal`
: example
  : ~~~ shell
    LOG_LEVEL=info
    ~~~

PID_DIR
: description
  : The PID directory path.
: required
  : false
: default
  : `/var/run/sensu`
: example
  : ~~~ shell
    PID_DIR=/var/run/sensu
    ~~~

USER
: description
  : The Sensu user to run the process as.
: required
  : false
: default
  : `sensu`
: example
  : ~~~ shell
    USER=sensu
    ~~~

SERVICE_MAX_WAIT
: description
  : The max wait time for process start/stop.
: required
  : false
: default
  : `10`
: example
  : ~~~ shell
    SERVICE_MAX_WAIT=10
    ~~~

# Manage the client process on Windows

The Sensu Core MSI package includes a Sensu client service wrapper, allowing Sensu to be registered as a Windows service. The Sensu client service wrapper uses an XML configuration file, to configure the `sensu-client` run arguments, e.g. `--log C:\opt\sensu\sensu-client.log`.

## Configure the client Windows service

Edit the Windows service definition for the Sensu client at `C:\opt\sensu\bin\sensu-client.xml`.

~~~ xml
  <!--
    Windows service definition for Sensu
  -->
  <service>
    <id>sensu-client</id>
    <name>Sensu Client</name>
    <description>This service runs a Sensu client</description>
    <executable>C:\opt\sensu\embedded\bin\ruby</executable>
    <arguments>C:\opt\sensu\embedded\bin\sensu-client -d C:\etc\sensu\conf.d -l C:\opt\sensu\sensu-client.log</arguments>
  </service>
~~~

For a full list of Sensu client command line arguments and their descriptions, run the following.

~~~ powershell
C:\opt\sensu\embedded\bin\sensu-client -h
~~~

## Create the client Windows service

Use the Windows SC command to create the service. The space between the equals(=) and the values is required.

~~~ powershell
sc \\HOSTNAME_OR_IP create sensu-client start= delayed-auto binPath= c:\opt\sensu\bin\sensu-client.exe DisplayName= "Sensu Client"
~~~

## Start the service {#start-the-service}

Start the Sensu Client service from the Services.msc panel or the Command Prompt. Review the C:\opt\sensu\sensu-client.log for errors.

# Client keepalives

## What are client keepalives? {#what-are-client-keepalives}

Sensu client keepalives are messages published to the Sensu transport every 20 seconds, containing the client configuration data. The Sensu client data within keepalives is stored in the Sensu client registry, by Sensu servers or Sensu Enterprise. The client data is used to add context to Sensu [events](events) and to detect Sensu clients in an unhealthy state. If a Sensu client fails to send keepalives, a Sensu server or Sensu Enterprise will detect the stale client data and create a keepalive event. Keepalive events can be used to identify unhealthy machines, network partitions, and event be used to deregister a client from the client registry (e.g. a virtual machine no longer exists).

## What are keepalive checks? {#what-are-keepalive-checks}

Sensu monitors the Sensu client registry for stale client data, detecting clients that have failed to send [client keepalives](#what-are-client-keepalives). A Sensu server or Sensu Enterprise will generate a keepalive check result on the behalf of Sensu clients that have failed to send a keepalive in a configurable amount of time (threshold). A client may fail to publish keepalives for several reasons: machine is down, excessive load, invalid client configuration, network issues, etc.

The following is an example of keepalive check result output.

~~~
No keepalive sent from client for 73 seconds (>=60)
~~~

## Client keepalive configuration

Sensu client keepalives are published to the Sensu transport every 20 seconds. The keepalive check can be configured per Sensu client, allowing each Sensu client to have its own alert thresholds and keepalive event handlers. By default, client data is considered stale if a keepalive hasn't be received in `120` seconds (WARNING). By default, keepalive events will be sent to the Sensu handler named `keepalive` if defined, or the `default` handler will be used.

To configure the keepalive check for a Sensu client, please refer to [the client keepalive attributes](#keepalive-attributes)

# Client socket input

Every Sensu client has a TCP & UDP socket listening for external check result input. The Sensu client socket(s) listen on `localhost` port `3030` by default and expect JSON formatted check results, allowing external sources (e.g. your application, which can be anything) to push check results without needing to know anything about Sensu's internal implementation. An excellent client socket use case example is a web application pushing check results to indicate database connectivity issues.

To configure the Sensu client socket for a client, please refer to [the client socket attributes](#socket-attributes).

## Example external check result input

The following is an example demonstrating external check result input via the Sensu client TCP socket. The example uses Bash's built-in `/dev/tcp` file to communicate with the Sensu client socket.

~~~ shell
echo '{"name": "app_01", "output": "could not connect to mysql", "status": 1}' > /dev/tcp/localhost/3030
~~~

Netcat can also be used, instead of the TCP file:

~~~ shell
echo '{"name": "app_01", "output": "could not connect to mysql", "status": 1}' | nc localhost 3030
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

Check results can include standard [check definition attributes](checks) (e.g. `handler`), as well as custom attributes to provide additional event context and/or assist in alert routing etc.

# Just in Time (JIT) clients {#jit-clients}

Sensu JIT clients are dynamically created clients, added to the client registry if a client does not already exist for a check result. If a check result includes a check `source`, a JIT client will be created for the source, and the check result will be stored under the newly created client. Sensu JIT clients allow Sensu clients (`sensu-client`) to monitor external resources on their behalf, using check `source` to create a JIT clients for the resources, used to store the execution history and provide context within event data. Client keepalive monitoring is disabled for JIT clients, as they do not have a corresponding "real" Sensu client (`sensu-client`).

By default, JIT client data includes a minimal number of attributes. The following is an example of JIT client data that is added to the registry.

~~~ json
{
  "name": "switch-y",
  "address": "unknown",
  "subscriptions": [],
  "keepalives": false
}
~~~

The Sensu API can be used to update the JIT client data in the registry. To update JIT client data, please refer to the Sensu API reference documentation for the POST /clients endpoint.
