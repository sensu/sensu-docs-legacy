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
- [HipChat](#hipchat) - send notifications to a Hipchat room for events
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
  : A set of attributes that configures the email event handler.
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

## Pagerduty

Create and resolve Pagerduty incidents for events. After configuring a
service in Pagerduty, configure the integration with the provided
service key. You may specify a request timeout, it defaults to 10
seconds.

~~~ json
{
    "pagerduty": {
        "service_key": "SERVICE_KEY",
        "timeout": 10
    }
}
~~~

## IRC

Send notifications to an IRC channel for events. Configure the
integration with IRC server connection information. The integration
supports NickServ and channel authentication. You may specify a
connection timeout, it defaults to 10 seconds.

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

## Slack

Send notifications to a Slack channel for events. Configure the
integration with Slack API information. You may specify a
connection timeout, it defaults to 10 seconds.

~~~ json
{
    "slack": {
        "webhook_url": "WEBHOOK_URL",
        "username": "sensu",
        "channel": "#ops",
        "timeout": 10
    }
}
~~~

## Hipchat

Send notifications to a Hipchat room for events. Configure the
integration with Hipchat API information. You may specify a
connection timeout, it defaults to 10 seconds.

~~~ json
{
    "hipchat": {
        "api_token": "API_TOKEN",
        "api_version": "v2",
        "username": "sensu",
        "room": "Operations",
        "timeout": 10
    }
}
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
