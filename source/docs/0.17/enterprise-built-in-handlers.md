---
version: 0.17
category: "Enterprise Docs"
title: "Built-in Handlers"
next:
  url: "enterprise-built-in-filters"
  text: "Enterprise Built-in Filters"
---

# Overview

Sensu Enterprise has many third-party integrations, provided by its built-in Sensu event handlers. Enterprise event handlers can be used to handle events for any check. The enterprise handlers (integrations) use their own global configuration in combination with [enterprise contact routing](enterprise-contact-routing) to provide the flexibility organizations require.

Built-in event handlers:

- [Email](#email) - send email notifications for events
- [PagerDuty](#pagerduty) - create and resolve PagerDuty incidents for events
- [IRC](#irc) - send notifications to an IRC channel for events
- [Slack](#slack) - send notifications to a Slack channel for events
- [HipChat](#hipchat) - send notifications to a HipChat room for events
- [Flapjack](#flapjack) - relay Sensu check results to Flapjack
- [EC2](#ec2) - deregister Sensu clients without an allowed EC2 instance state
- [Chef](#chef) - deregister Sensu clients without an associated Chef node
- [Graphite](#graphite) - send metrics to Graphite
- [Librato](#librato) - send metrics to Librato Metrics

The following is an example of how to configure a Sensu check to use the built-in `email` enterprise handler (integration).

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

# Enterprise handlers

## Email

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

### Definition attributes

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

## PagerDuty

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

### Definition attributes

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

## IRC

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

### Definition attributes

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

## Slack

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

### Definition attributes

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

## HipChat

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

### Definition attributes

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

#### Hipchat attributes

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

## Flapjack

Relay Sensu results to Flapjack, a monitoring notification routing and
event processing system.

~~~ json
{
    "flapjack": {
        "host": "redis.example.com",
        "port": 6379,
        "channel": "events",
        "db": 0,
        "filter_metrics": false
    }
}
~~~

## EC2

Deregister Sensu clients from the registry, if they no longer have an
associated EC2 instance in the allowed state(s). This integration can
only work if Sensu clients are named using the EC2 instance ID, for
the instance on which they reside. Configure the integration with AWS API
credentials, with the appropriate access. When using AWS IAM user
credentials, it must have the EC2 describe instances action in its
policy, eg. `ec2:DescribeInstances`.

~~~ json
{
    "ec2": {
        "region": "us-west-2",
        "access_key_id": "ACCESS_KEY_ID",
        "secret_access_key": "SECRET_ACCESS_KEY",
        "allowed_instance_states": ["running"],
        "timeout": 10
    }
}
~~~

## Chef

Deregister Sensu clients from the registry, if they no longer have
associated Chef node data. This integration can only work if Sensu
clients are named using the Chef node name, for the machine on which
they reside. Configure the integration with Chef API information. You
may use the local chef-client configuration as a reference.

~~~ json
{
    "chef": {
        "endpoint": "https://api.opscode.com/organizations/example",
        "flavor": "enterprise",
        "client": "example",
        "key": "/etc/chef/example.pem",
        "ssl_pem_file": "/etc/chef/ssl.pem",
        "ssl_verify": true,
        "proxy_username": "PROXY_USER",
        "proxy_password": "PROXY_PASSWORD",
        "proxy_address": "proxy.example.com",
        "proxy_port": 8080,
        "timeout": 10
    }
}
~~~

## Graphite

Send check metric data to Graphite (TCP).

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

## Librato

Send check metric data to Librato (HTTP).

~~~ json
{
    "librato": {
        "email": "support@example.com",
        "api_key": "API_KEY"
    }
}
~~~
