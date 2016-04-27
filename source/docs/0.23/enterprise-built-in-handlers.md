---
version: 0.23
category: "Enterprise Docs"
title: "Built-in Handlers"
next:
  url: "enterprise-built-in-filters"
  text: "Enterprise Built-in Filters"
---

# Integrated Handlers in Sensu Enterprise

Sensu Enterprise has many third-party integrations, provided by its built-in Sensu event handlers. Enterprise event handlers can be used to handle events for any check. The enterprise handlers (integrations) use their own global configuration in combination with [enterprise contact routing](enterprise-contact-routing) to provide the flexibility organizations require.

Built-in event handlers:

- [Email](#email) - send email notifications for events
- [PagerDuty](#pagerduty) - create and resolve PagerDuty incidents for events
- [VictorOps](#victorops) - create and resolve VictorOps messages for events
- [OpsGenie](#opsgenie) - create and close OpsGenie alerts for events
- [ServiceNow](#servicenow) - create ServiceNow CMDB configuration items and incidents
- [IRC](#irc) - send notifications to an IRC channel for events
- [Slack](#slack) - send notifications to a Slack channel for events
- [HipChat](#hipchat) - send notifications to a HipChat room for events
- [SNMP](#snmp) - send SNMP traps to a SNMP manager
- [DataDog](#datadog) - create Datadog events
- [Flapjack](#flapjack) - relay Sensu check results to Flapjack
- [EC2](#ec2) - deregister Sensu clients without an allowed EC2 instance state
- [Chef](#chef) - deregister Sensu clients without an associated Chef node
- [Graphite](#graphite) - send metrics to Graphite
- [OpenTSDB](#opentsdb) - send metrics to OpenTSDB
- [Librato](#librato) - send metrics to Librato Metrics
- [InfluxDB](#influxdb) - send metrics to InfluxDB

## Using Enterprise handlers

After configuring one or more [enterprise handlers](#enterprise-handlers), you can specify which ones are used per check or create a default handler set to specify those used by default.

### Example Enterprise handler configurations

The following is an example of how to configure a Sensu check to use the built-in `email` enterprise handler (integration).

`/etc/sensu/conf.d/checks/load_balancer_listeners.json`

~~~ json
{
  "checks": {
    "load_balancer_listeners": {
      "command": "check-haproxy.rb -s /var/run/haproxy.sock -A",
      "subscribers": [
        "load_balancer"
      ],
      "interval": 20,
      "handler": "email"
    }
  }
}
~~~

The following is an example of how to configure the Sensu default handler in order to specify one or more built-in enterprise handlers. The default handler is used when a check definition does not specify one or more event handlers. This example specifies the built-in `email` and `slack` enterprise handlers.

`/etc/sensu/conf.d/handlers/default.json`

~~~ json
{
  "handlers": {
    "default": {
      "type": "set",
      "handlers": [
        "email",
        "slack"
      ]
    }
  }
}
~~~

## Enterprise handlers

### Email

Send email notifications for events, using SMTP.

The following is an example global configuration for the `email` enterprise event handler (integration).

~~~ json
{
  "email": {
    "smtp": {
      "address": "smtp.example.com",
      "port": 587,
      "openssl_verify_mode": "none",
      "enable_starttls_auto": true,
      "authentication": "plain",
      "user_name": "postmaster@example.com",
      "password": "SECRET"
    },
    "to": "support@example.com",
    "from": "noreply@example.com",
    "timeout": 10
  }
}
~~~

#### Definition attributes

email
: description
  : A set of attributes that configure the Email event handler.
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "email": {}
    ~~~

#### Email attributes

smtp
: description
  : A set of attributes that provides SMTP connection information to the email event handler.
: required
  : false
: type
  : Hash
: default
  : ~~~ shell
    "smtp": {
      "address": "127.0.0.1",
      "port": 25,
      "domain": "localhost.localdomain",
      "openssl_verify_mode": "none",
      "enable_starttls_auto": true,
      "user_name": null,
      "password": null,
      "authentication": "plain"
    }
    ~~~
: example
  : ~~~ shell
    "smtp": {
      "address": "smtp.example.com",
      "port": 587
    }
    ~~~

to
: description
  : The default email address to send notification to.
: required
  : false
: type
  : String
: default
  : `root@localhost`
: example
  : ~~~ shell
    "to": "support@example.com"
    ~~~

from
: description
  : The default email address to use as the sender.
: required
  : false
: type
  : String
: default
  : `sensu@localhost`
: example
  : ~~~ shell
    "from": "noreply@example.com"
    ~~~

timeout
: description
  : The handler execution duration timeout in seconds (hard stop).
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

### PagerDuty

Create and resolve PagerDuty incidents for events. After [configuring a service in PagerDuty](https://support.pagerduty.com/hc/en-us/articles/202830340-Creating-a-Generic-API-Service), configure the handler (integration) with the provided service key.

The following is an example global configuration for the `pagerduty` enterprise event handler (integration).

~~~ json
{
  "pagerduty": {
    "service_key": "r3FPuDvNOTEDyQYCc7trBkymIFcy2NkE",
    "timeout": 10
  }
}
~~~

#### Definition attributes

pagerduty
: description
  : A set of attributes that configure the PagerDuty event handler.
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "pagerduty": {}
    ~~~

#### Pagerduty attributes

service_key
: description
  : The PagerDuty service key to use when creating and resolving incidents.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "service_key": "r3FPuDvNOTEDyQYCc7trBkymIFcy2NkE"
    ~~~

timeout
: description
  : The handler execution duration timeout in seconds (hard stop).
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

### VictorOps

Create VictorOps messages for events.

The following is an example global configuration for the `victorops` enterprise event handler (integration).

~~~ json
{
  "victorops": {
    "api_key": "a53265cd-d2ef-fa32-fc54de52659a",
    "routing_key": "everyone",
    "timeout": 10
  }
}
~~~

#### Definition attributes

victorops
: description
  : A set of attributes that configure the VictorOps event handler.
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "victorops": {}
    ~~~

#### VictorOps attributes

api_key
: description
  : The VictorOps api key to use when creating messages.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "api_key": "a53265cd-d2ef-fa32-fc54de52659a"
    ~~~

routing_key
: description
  : The VictorOps routing key to decide what team(s) to send alerts to.
: required
  : false
: type
  : String
: default
  : `everyone`
: example
  : ~~~ shell
    "routing_key": "ops"
    ~~~

timeout
: description
  : The handler execution duration timeout in seconds (hard stop).
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

### OpsGenie

Create and close [OpsGenie](https://www.opsgenie.com/) alerts for events.

The following is an example global configuration for the `opsgenie` enterprise event handler (integration).

~~~ json
{
  "opsgenie": {
    "api_key": "eed02a0d-85a4-427b-851a-18dd8fd80d93",
    "source": "Sensu Enterprise (AWS)",
    "teams": ["ops", "web"],
    "recipients": ["afterhours"],
    "tags": ["production"],
    "overwrites_quiet_hours": true,
    "timeout": 10
  }
}
~~~

#### Definition attributes

opsgenie
: description
  : A set of attributes that configure the OpsGenie event handler.
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "opsgenie": {}
    ~~~

#### OpsGenie attributes

api_key
: description
  : The OpsGenie Alert API key to use when creating/closing alerts.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "api_key": "eed02a0d-85a4-427b-851a-18dd8fd80d93"
    ~~~

source
: description
  : The source to use for OpsGenie alerts.
: required
  : false
: type
  : String
: default
  : `Sensu Enterprise`
: example
  : ~~~ shell
    "source": "Sensu (us-west-1)"
    ~~~

teams
: description
  : An array of OpsGenie team names to be used to calculate which users will be responsible for created alerts.
: required
  : false
: type
  : Array
: default
  : `[]`
: example
  : ~~~ shell
    "teams": ["ops", "web"]
    ~~~

recipients
: description
  : An array of OpsGenie group, schedule, or escalation names to be used to calculate which users will be responsible for created alerts.
: required
  : false
: type
  : Array
: default
  : `[]`
: example
  : ~~~ shell
    "recipients": ["web", "afterhours"]
    ~~~

tags
: description
  : An array of OpsGenie alert tags that will be added to created alerts.
: required
  : false
: type
  : Array
: default
  : `[]`
: example
  : ~~~ shell
    "tags": ["production"]
    ~~~

overwrites_quiet_hours
: description
  : If events with a critical severity should be tagged with "OverwritesQuietHours". This tag can be used to bypass quiet (or off) hour alert notification filtering.
: required
  : false
: type
  : Boolean
: default
  : `false`
: example
  : ~~~ shell
    "overwrites_quiet_hours": true
    ~~~

timeout
: description
  : The handler execution duration timeout in seconds (hard stop).
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

### ServiceNow

Create ServiceNow configuration items and create/resolve ServiceNow incidents.

The following is an example global configuration for the `servicenow` enterprise event handler (integration).

~~~ json
{
  "servicenow": {
    "host": "dev42.service-now.com",
    "user": "admin",
    "password": "secret",
    "create_cmdb_ci": true,
    "cmdb_ci_table": "cmdb_ci_server",
    "timeout": 10
  }
}
~~~

#### Definition attributes

servicenow
: description
  : A set of attributes that configure the ServiceNow event handler.
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "servicenow": {}
    ~~~

#### ServiceNow attributes

host
: description
  : The ServiceNow host address.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "host": "dev42.service-now.com"
    ~~~

user
: description
  : The ServiceNow user used to authenticate.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "user": "admin"
    ~~~

password
: description
  : The ServiceNow user password.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "password": "secret"
    ~~~

create_cmdb_ci
: description
  : If ServiceNow CMDB configuration items should be automatically created for Sensu clients.
: required
  : false
: type
  : Boolean
: default
  : `true`
: example
  : ~~~ shell
    "create_cmdb_ci": false
    ~~~

cmdb_ci_table
: description
  : The ServiceNow CMDB table used for automated configuration item creation.
: required
  : false
: type
  : String
: default
  : `cmdb_ci_server`
: example
  : ~~~ shell
    "cmdb_ci_table": "cmdb_ci_sensu_client"
    ~~~

timeout
: description
  : The handler execution duration timeout in seconds (hard stop).
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

### IRC

Send notifications to an IRC channel for events.

The following is an example global configuration for the `irc` enterprise event handler (integration).

~~~ json
{
  "irc": {
    "uri": "irc://nick:pass@example.com:6697/#ops",
    "ssl": true,
    "nickserv_password": "NICKSERV_PASSWORD",
    "channel_password": "CHANNEL_PASSWORD",
    "join": false,
    "timeout": 10
  }
}
~~~

#### Definition attributes

irc
: description
  : A set of attributes that configure the IRC event handler.
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "irc": {}
    ~~~

#### IRC attributes

uri
: description
  : The IRC URI; including the nick, password, address, port, and channel.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "uri": "irc://nick:pass@example.com:6697/#ops"
    ~~~

ssl
: description
  : If SSL encryption is used for the IRC connection.
: required
  : false
: type
  : Boolean
: default
  : `false`
: example
  : ~~~ shell
    "ssl": true
    ~~~

channel_password
: description
  : The IRC channel password (if required).
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "channel_password": "secret"
    ~~~

nickserv_password
: description
  : Identify with NickServ (if required).
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "nickserv_password": "secret"
    ~~~

join
: description
  : If the handler must join the IRC channel before messaging.
: required
  : false
: type
  : Boolean
: default
  : `false`
: example
  : ~~~ shell
    "join": true
    ~~~

timeout
: description
  : The handler execution duration timeout in seconds (hard stop).
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

### Slack

Send notifications to a Slack channel for events. After [configuring an incoming webhook in Slack](https://api.slack.com/incoming-webhooks), configure the handler (integration) with the provided webhook url.

The following is an example global configuration for the `slack` enterprise event handler (integration).

~~~ json
{
  "slack": {
    "webhook_url": "https://hooks.slack.com/services/IB6JgRmRJ/eL7Hgo6kF/CckJm8E4Yt8X3i6QRKHWBekc",
    "username": "sensu",
    "channel": "#ops",
    "timeout": 10
  }
}
~~~

#### Definition attributes

slack
: description
  : A set of attributes that configure the Slack event handler.
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "slack": {}
    ~~~

#### Slack attributes

webhook_url
: description
  : The Slack incoming webhook URL - [https://api.slack.com/incoming-webhooks](https://api.slack.com/incoming-webhooks).
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "webhook_url": "https://hooks.slack.com/services/IB6JgRmRJ/eL7Hgo6kF/CckJm8E4Yt8X3i6QRKHWBekc"
    ~~~

channel
: description
  : The Slack channel to notify.
: required
  : false
: type
  : String
: default
  : `#general`
: example
  : ~~~ shell
    "channel": "#ops"
    ~~~

username
: description
  : The Slack username to use to notify the channel.
: required
  : false
: type
  : String
: default
  : `sensu`
: example
  : ~~~ shell
    "username": "monitoring"
    ~~~

icon_url
: description
  : The Slack icon URL to use for notifications.
: required
  : false
: type
  : String
: default
  : `http://www.gravatar.com/avatar/9b37917076cee4e2d331a785f3426640`
: example
  : ~~~ shell
    "icon_url": "http://www.gravatar.com/avatar/9b37917076cee4e2d331a785f3426640"
    ~~~

timeout
: description
  : The handler execution duration timeout in seconds (hard stop).
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

### HipChat

Send notifications to a HipChat room for events. After [creating a HipChat API token](https://www.hipchat.com/docs/api/auth), configure the handler (integration) with the provided API token.

The following is an example global configuration for the `hipchat` enterprise event handler (integration).

~~~ json
{
  "hipchat": {
    "api_token": "L7kVQzXF7c5eUMYUon6INaSVRDU8mP",
    "api_version": "v2",
    "username": "sensu",
    "room": "Operations",
    "timeout": 10
  }
}
~~~

#### Definition attributes

hipchat
: description
  : A set of attributes that configure the HipChat event handler.
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "hipchat": {}
    ~~~

#### HipChat attributes

api_token
: description
  : The HipChat API token - [https://www.hipchat.com/docs/api/auth](https://www.hipchat.com/docs/api/auth).
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "api_token": "L7kVQzXF7c5eUMYUon6INaSVRDU8mP"
    ~~~

server_url
: description
  : The URL of the HipChat server (used for self-hosted HipChat installations)
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "server_url": "https://hipchat.example.com"
    ~~~

api_version
: description
  : The HipChat API version to use.
: required
  : false
: type
  : String
: default
  : `v2`
: example
  : ~~~ shell
    "api_version": "v2"
    ~~~

username
: description
  : The HipChat username to use to notify the room.
: required
  : false
: type
  : String
: default
  : `sensu`
: example
  : ~~~ shell
    "username": "monitoring"
    ~~~

room
: description
  : The HipChat room to notify.
: required
  : false
: type
  : String
: default
  : `sensu`
: example
  : ~~~ shell
    "room": "Search"
    ~~~

timeout
: description
  : The handler execution duration timeout in seconds (hard stop).
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

### SNMP

Send SNMP traps to a SNMP manager.

Sensu Enterprise provides two SNMP MIBs (management information base) for this integration. The SNMP integration is capable of creating either SNMPv1 or SNMPv2 traps for Sensu events. By default, SNMPv2 traps are created unless the integration is configured for SNMPv1, e.g. `"version": 1`.  The SNMP manager that will be receiving SNMP traps from Sensu Enterprise should load the appropriate provided MIBs. The Sensu Enterprise SNMP MIB files can be altered to better fit certain environments and SNMP configurations.

_NOTE: Sensu Enterprise 1.3.0 changed the default SNMP trap version from `1` to `2`_

SNMPv1 MIBs:

- [RFC-1212-MIB.txt](http://sensuapp.org/docs/0.23/files/RFC-1212-MIB.txt)

- [RFC-1215-MIB.txt](http://sensuapp.org/docs/0.23/files/RFC-1215-MIB.txt)

- [SENSU-ENTERPRISE-V1-MIB.txt](http://sensuapp.org/docs/0.23/files/SENSU-ENTERPRISE-V1-MIB.txt)

SNMPv2 MIBs:

- [SENSU-ENTERPRISE-ROOT-MIB.txt](http://sensuapp.org/docs/0.23/files/SENSU-ENTERPRISE-ROOT-MIB.txt)

- [SENSU-ENTERPRISE-NOTIFY-MIB.txt](http://sensuapp.org/docs/0.23/files/SENSU-ENTERPRISE-NOTIFY-MIB.txt)

The following is an example global configuration for the `snmp` enterprise event handler (integration).

~~~ json
{
  "snmp": {
    "host": "8.8.8.8",
    "port": 162,
    "community": "public",
    "version": 2
  }
}
~~~

#### Definition attributes

snmp
: description
  : A set of attributes that configure the SNMP event handler.
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "snmp": {}
    ~~~

#### SNMP attributes

host
: description
  : The SNMP manager host address.
: required
  : false
: type
  : String
: default
  : `127.0.0.1`
: example
  : ~~~ shell
    "host": "8.8.8.8"
    ~~~

port
: description
  : The SNMP manager trap port (UDP).
: required
  : false
: type
  : Integer
: default
  : `162`
: example
  : ~~~ shell
    "port": 162
    ~~~

community
: description
  : The SNMP community string to use when sending traps.
: required
  : false
: type
  : String
: default
  : `public`
: example
  : ~~~ shell
    "community": "private"
    ~~~

### Datadog

Create Datadog events for Sensu events. After [managing your Datadog account API key](https://app.datadoghq.com/account/login?next=%2Faccount%2Fsettings#api), configure the handler (integration) with your API key.

The following is an example global configuration for the `datadog` enterprise event handler (integration).

~~~ json
{
  "datadog": {
    "api_key": "9775a026f1ca7d1c6c5af9d94d9595a4",
    "timeout": 10
  }
}
~~~

#### Definition attributes

datadog
: description
  : A set of attributes that configure the Datadog event handler.
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "datadog": {}
    ~~~

#### Datadog attributes

api_key
: description
  : The Datadog account API key to use when creating Datadog events.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "api_key": "9775a026f1ca7d1c6c5af9d94d9595a4"
    ~~~

timeout
: description
  : The handler execution duration timeout in seconds (hard stop).
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

### Flapjack

Relay Sensu results to Flapjack, a monitoring notification routing and event processing system. Flapjack uses Redis for event queuing; this integration sends event data to Flapjack through Redis, using the Flapjack event format.

_NOTE: checks **DO NOT** need to specify `flapjack` as an event handler, as every check result will be relayed to Flapjack if the integration is configured._

The following is an example global configuration for the `flapjack` enterprise integration.

~~~ json
{
  "flapjack": {
    "host": "redis.example.com",
    "port": 6379,
    "db": 0,
    "channel": "events",
    "filter_metrics": false
  }
}
~~~

#### Definition attributes

flapjack
: description
  : A set of attributes that configure the Flapjack integration.
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "flapjack": {}
    ~~~

#### Flapjack attributes

host
: description
  : The Flapjack Redis instance address.
: required
  : false
: type
  : String
: default
  : `127.0.0.1`
: example
  : ~~~ shell
    "host": "8.8.8.8"
    ~~~

port
: description
  : The Flapjack Redis instance port.
: required
  : false
: type
  : Integer
: default
  : `6379`
: example
  : ~~~ shell
    "port": 6380
    ~~~

db
: description
  : The Flapjack Redis instance database (#) to use.
: required
  : false
: type
  : Integer
: default
  : `0`
: example
  : ~~~ shell
    "db": 1
    ~~~

channel
: description
  : The Flapjack Redis instance channel (queue) to use for events.
: required
  : false
: type
  : String
: default
  : `events`
: example
  : ~~~ shell
    "channel": "flapjack"
    ~~~

filter_metrics
: description
  : If check results with a `type` of `metric` are relayed to Flapjack.
: required
  : false
: type
  : Boolean
: default
  : `false`
: example
  : ~~~ shell
    "filter_metrics": true
    ~~~

### EC2

Deregister Sensu clients from the client registry, if they no longer have an associated EC2 instance in the allowed state(s). This enterprise handler (integration) will only work if Sensu clients are named using the EC2 instance ID, for the instance on which they reside. The `ec2` enterprise handler requires valid [AWS IAM user credentials](http://aws.amazon.com/iam/) with the EC2 describe instances action in a policy, e.g. `ec2:DescribeInstances`.

The following is an example global configuration for the `ec2` enterprise handler (integration).

~~~ json
{
  "ec2": {
    "region": "us-west-2",
    "access_key_id": "AlygD0X6Z4Xr2m3gl70J",
    "secret_access_key": "y9Jt5OqNOqdy5NCFjhcUsHMb6YqSbReLAJsy4d6obSZIWySv",
    "allowed_instance_states": ["running"],
    "timeout": 10
  }
}
~~~

The EC2 enterprise handler is most commonly used as part of the `keepalive` set handler. For example:

~~~ json
{
  "handlers": {
    "keepalive": {
      "type": "set",
      "handlers": [
        "slack",
        "ec2"
      ]
    }
  }
}
~~~

#### Definition attributes

ec2
: description
  : A set of attributes that configure the EC2 event handler.
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "ec2": {}
    ~~~

#### EC2 attributes

region
: description
  : The AWS EC2 region to query for EC2 instance state(s).
: required
  : false
: type
  : String
: default
  : `us-east-1`
: example
  : ~~~ shell
    "region": "us-west-1"
    ~~~

access_key_id
: description
  : The AWS IAM user access key ID to use when querying the EC2 API.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "access_key_id": "AlygD0X6Z4Xr2m3gl70J"
    ~~~

secret_access_key
: description
  : The AWS IAM user secret access key to use when querying the EC2 API.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "secret_access_key": "y9Jt5OqNOqdy5NCFjhcUsHMb6YqSbReLAJsy4d6obSZIWySv"
    ~~~

allowed_instance_states
: description
  : An array of allowed EC2 instance states. Each array item must each be a string. Any other state(s) will cause the Sensu client to be deregistered.
: required
  : false
: type
  : Array
: allowed values
  : `running`, `stopping`, `stopped`, `shutting-down`, `terminated`, `rebooting`, `pending`
: default
  : `["running"]`
: example
  : ~~~ shell
    "allowed_instance_states": ["running", "rebooting"]
    ~~~

timeout
: description
  : The handler execution duration timeout in seconds (hard stop).
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

### Chef

Deregister Sensu clients from the client registry, if they no longer have associated Chef node data. This integration can only work if Sensu clients are named using the Chef node name, for the machine on which they reside. The `chef` enterprise handler requires Chef Server API credentials, the local chef-client configuration can be used as a reference.

The following is an example global configuration for the `chef` enterprise handler (integration).

~~~ json
{
  "chef": {
    "endpoint": "https://api.opscode.com/organizations/example",
    "flavor": "enterprise",
    "client": "i-424242",
    "key": "/etc/chef/i-424242.pem",
    "ssl_pem_file": "/etc/chef/ssl.pem",
    "ssl_verify": true,
    "proxy_address": "proxy.example.com",
    "proxy_port": 8080,
    "proxy_username": "chef",
    "proxy_password": "secret",
    "timeout": 10
  }
}
~~~

The Chef enterprise handler is most commonly used as part of the `keepalive` set handler. For example:

~~~ json
{
  "handlers": {
    "keepalive": {
      "type": "set",
      "handlers": [
        "pagerduty",
        "chef"
      ]
    }
  }
}
~~~

#### Definition attributes

chef
: description
  : A set of attributes that configure the Chef event handler.
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "chef": {}
    ~~~

#### Chef attributes

endpoint
: description
  : The Chef Server API endpoint (URL).
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "endpoint": "https://api.opscode.com/organizations/example"
    ~~~

flavor
: description
  : The Chef Server flavor (is it enterprise?).
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "flavor": "enterprise"
    ~~~

client
: description
  : The Chef Client name to use when authenticating/querying the Chef Server API.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "client": "i-424242"
    ~~~

key
: description
  : The Chef Client key to use when authenticating/querying the Chef Server API.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "key": "/etc/chef/i-424242.pem"
    ~~~

ssl_pem_file
: description
  : The Chef SSL pem file use when querying the Chef Server API.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "ssl_pem_file": "/etc/chef/ssl.pem"
    ~~~

ssl_verify
: description
  : If the SSL certificate will be verified when querying the Chef Server API.
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

proxy_address
: description
  : The HTTP proxy address.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "proxy_address": "proxy.example.com"
    ~~~

proxy_port
: description
  : The HTTP proxy port (if there is a proxy).
: required
  : false
: type
  : Integer
: example
  : ~~~ shell
    "proxy_port": 8080
    ~~~

proxy_username
: description
  : The HTTP proxy username (if there is a proxy).
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "proxy_username": "chef"
    ~~~

proxy_password
: description
  : The HTTP proxy user password (if there is a proxy).
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "proxy_password": "secret"
    ~~~

timeout
: description
  : The handler execution duration timeout in seconds (hard stop).
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

### Graphite

Send metrics to Graphite, using the plaintext protocol over TCP. The `graphite` enterprise handler is also capable of sending metrics to [Hosted Graphite](https://www.hostedgraphite.com/), using the `prefix` attribute to prefix metric names with the Hosted Graphite API key. This handler uses the `output_format` mutator.

The following is an example global configuration for the `graphite` enterprise handler (integration).

~~~ json
{
  "graphite": {
    "host": "graphite.example.com",
    "port": 2003,
    "prefix_client_name": false,
    "prefix": "production"
  }
}
~~~

#### Definition attributes

graphite
: description
  : A set of attributes that configure the Graphite event handler.
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "graphite": {}
    ~~~

#### Graphite attributes

host
: description
  : The Graphite Carbon host address.
: required
  : false
: type
  : String
: default
  : `127.0.0.1`
: example
  : ~~~ shell
    "host": "carbon.hostedgraphite.com"
    ~~~

port
: description
  : The Graphite Carbon port.
: required
  : false
: type
  : Integer
: default
  : `2003`
: example
  : ~~~ shell
    "port": 3003
    ~~~

prefix_client_name
: description
  : If the Sensu client name should prefix (added to) the metric names.
: required
  : false
: type
  : Boolean
: default
  : `false`
: example
  : ~~~ shell
    "prefix_client_name": true
    ~~~

prefix
: description
  : A custom metric name prefix - this can be used to prefix the Hosted Graphite API key.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "prefix": "production"
    ~~~

### OpenTSDB

Send metrics to OpenTSDB, using the telnet protocol (TCP). This handler uses the [`output_format` mutator](https://sensuapp.org/docs/latest/enterprise-built-in-mutators#output-format).

The following is an example global configuration for the `opentsdb` enterprise handler (integration).

~~~ json
{
  "opentsdb": {
    "host": "opentsdb.example.com",
    "port": 4242,
    "tag_host": true
  }
}
~~~

#### Definition attributes

opentsdb
: description
  : A set of attributes that configure the OpenTSDB event handler.
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "opentsdb": {}
    ~~~

#### OpenTSDB attributes

host
: description
  : The OpenTSDB host address.
: required
  : false
: type
  : String
: default
  : `127.0.0.1`
: example
  : ~~~ shell
    "host": "opentsdb.example.com"
    ~~~

port
: description
  : The OpenTSDB telnet listener port.
: required
  : false
: type
  : Integer
: default
  : `4242`
: example
  : ~~~ shell
    "port": 4444
    ~~~

tag_host
: description
  : If automatic host tagging should be used for metric data points. The Sensu client `name` is used as the `host` tag value. The OpenTSDB handler will always add a `host` tag to metric data points that do not have tags.
: required
  : false
: type
  : Boolean
: default
  : `true`
: example
  : ~~~ shell
    "tag_host": false
    ~~~

### Librato

Send metrics to Librato Metrics using the HTTP API.

The following is an example global configuration for the `librato` enterprise handler (integration).

~~~ json
{
  "librato": {
    "email": "support@example.com",
    "api_key": "90SHpjPOFqd2YJFIX9rzDq7ik6CiDmqu2AvqcXJAX3buIwcOGqIOgNilwKMjpStO"
  }
}
~~~

#### Definition attributes

librato
: description
  : A set of attributes that configure the Librato event handler.
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "librato": {}
    ~~~

#### Librato attributes

email
: description
  : The Librato account email.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "email": "support@example.com"
    ~~~

api_key
: description
  : The Librato account API key.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "api_key": "90SHpjPOFqd2YJFIX9rzDq7ik6CiDmqu2AvqcXJAX3buIwcOGqIOgNilwKMjpStO"
    ~~~

### InfluxDB

Send metrics to InfluxDB using the HTTP API.

The following is an example global configuration for the `influxdb` enterprise handler (integration).

~~~ json
{
  "influxdb": {
    "host": "8.8.8.8",
    "port": 8086,
    "username": "root",
    "password": "Bfw3Bdrn5WfqvOl1",
    "api_version": "0.9"
  }
}
~~~

#### Definition attributes

influxdb
: description
  : A set of attributes that configure the InfluxDB event handler.
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "influxdb": {}
    ~~~

#### InfluxDB attributes

host
: description
  : The InfluxDB host address.
: required
  : false
: type
  : String
: default
  : `127.0.0.1`
: example
  : ~~~ shell
    "host": "8.8.8.8"
    ~~~

port
: description
  : The InfluxDB HTTP API port.
: required
  : false
: type
  : Integer
: default
  : `8086`
: example
  : ~~~ shell
    "port": 9096
    ~~~

username
: description
  : The InfluxDB username.
: required
  : false
: type
  : String
: default
  : `root`
: example
  : ~~~ shell
    "username": "sensu"
    ~~~

password
: description
  : The InfluxDB user password.
: required
  : false
: type
  : String
: default
  : `root`
: example
  : ~~~ shell
    "password": "secret"
    ~~~

database
: description
  : The InfluxDB database (name) to use.
: required
  : false
: type
  : String
: default
  : `db`
: example
  : ~~~ shell
    "database": "sensu"
    ~~~

api_version
: description
  : The InfluxDB API version.
: required
  : false
: type
  : String
: allowed values
  : `0.8`, `0.9`
: default
  : `0.8`
: example
  : ~~~ shell
    "api_version": "0.9"
    ~~~

timeout
: description
  : The InfluxDB HTTP API POST timeout (write).
: required
  : false
: type
  : Integer
: default
  : `10`
: example
  : ~~~ shell
    "timeout": 3
    ~~~
