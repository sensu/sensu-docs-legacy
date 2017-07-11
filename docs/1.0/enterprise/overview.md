---
title: "Sensu Enterprise"
version: 1.0
weight: 1
next:
  url: "dashboard.html"
  text: "Sensu Enterprise Dashboard"
---

# Sensu Enterprise

## Overview

- [What is Sensu Enterprise?](#what-is-sensu-enterprise)
- [Upgrading to Sensu Enterprise](#upgrading-to-sensu-enterprise)
- [Reference documentation](#reference-documentation)

## What is Sensu Enterprise?

[Sensu Enterprise][1] is a drop-in replacement for Sensu Core (the FREE, open
source version of Sensu), that provides added-value features like [contact
routing][2], several built-in [third-party integrations][3], and more. Sensu
Enterprise also includes FREE annual [training][4] and [enterprise-class
support][5].

We like to think of the distinction between Sensu Core and Sensu Enterprise as
the difference between a framework and a product. The purpose of this
documentation is to help Sensu Enterprise users configure their installation,
making use of the many third-party integrations and features Sensu Enterprise
has to offer. Sensu Enterprise integrates with third-party tools & services to
provide support for creating/resolving incidents, on-call rotation scheduling,
storing time series data (metrics), relaying events, deregistering sensu-clients
for terminated nodes, and/or notifying contacts via various media.

## Upgrading to Sensu Enterprise

Sensu Enterprise is designed to be a drop-in replacement for the Sensu Core
[server][6] and [API][7], so for users who are upgrading to Sensu Enterprise
from Sensu Core, no configuration changes are required to resume – simply
terminate the `sensu-server` and `sensu-api` processes, and start the
`sensu-enterprise` process to resume  operation of Sensu (see the [Sensu Server
and API installation guide][8] for  additional details). However, some
configuration changes may be required to take  advantage of certain third-party
integrations or added-value features (e.g. contact routing). Please refer to the
[Sensu Enterprise reference documentation][9] (below), for more
information.

## Reference documentation

- [Sensu Enterprise Dashboard](dashboard.html)
  - [Role-based access controls](rbac/overview.html)
    - [RBAC for LDAP](rbac/rbac-for-ldap.html)
    - [RBAC for GitHub](rbac/rbac-for-github.html)
    - [RBAC for GitLab](rbac/rbac-for-gitlab.html)
  - [Audit Logging](rbac/audit-logging.html)
  - [Collections](collections.html)
  - [Heads up display](hud.html)
- [Sensu Enterprise API](api.html)
- [Contact routing](contact-routing.html)
- [Built-in handlers (integrations)](built-in-handlers.html)
  - [Email](integrations/email.html)
  - [PagerDuty](integrations/pagerduty.html)
  - [ServiceNow](integrations/servicenow.html)
  - [VictorOps](integrations/victorops.html)
  - [OpsGenie](integrations/opsgenie.html)
  - [Slack](integrations/slack.html)
  - [HipChat](integrations/hipchat.html)
  - [IRC](integrations/irc.html)
  - [SNMP](integrations/snmp.html)
  - [Graylog](integrations/graylog.html)
  - [Flapjack](integrations/flapjack.html)
  - [Puppet](integrations/puppet.html)
  - [Chef](integrations/chef.html)
  - [EC2](integrations/ec2.html)
  - [Event Stream](integrations/event_stream.html)
  - [Graphite](integrations/graphite.html)
  - [Librato](integrations/librato.html)
  - [OpenTSDB](integrations/opentsdb.html)
  - [InfluxDB](integrations/influxdb.html)
  - [DataDog](integrations/datadog.html)
- [Built-in filters](built-in-filters.html)


[1]:  /enterprise
[2]:  contact-routing.html
[3]:  built-in-handlers.html
[4]:  /training
[5]:  /support
[6]:  ../reference/server.html
[7]:  ../api/overview.html
[8]:  ../installation/install-sensu-server-api.html#sensu-enterprise
[9]:  #reference-documentation
