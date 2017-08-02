---
title: "Frequently Asked Questions"
description: "Sensu Frequently Asked Questions"
version: 0.28
weight: 6
---

# Sensu Frequently Asked Questions

Please note the following frequently asked questions about Sensu Core, Sensu
Enterprise, Sensu Training, Professional Services for Sensu, and more. If you
need support for Sensu, please consider giving [Sensu
Enterprise](https://sensuapp.org/get-started/) a try.

> Do I need RabbitMQ to be installed on every system I wish to monitor?

**No.** Sensu uses [RabbitMQ](/reference/rabbitmq/) as a
[Transport](/reference/transport/). Sensu services require access to a shared
instance of the defined Sensu Transport (e.g. a RabbitMQ cluster) to function.
Sensu check requests and check results are published as "messages" to the Sensu
Transport, and the corresponding Sensu services receive these messages by
subscribing to the appropriate subscription topics.

> Does Redis need to be installed on every system I wish to monitor?

**No.** Sensu uses [Redis](/reference/redis/) as a data store,
and the Sensu server services (i.e. `sensu-server` & `sensu-api` for
Sensu Core; `sensu-enterprise` for Sensu Enterprise) require access to
the same Redis instance (or cluster) to store and access the Sensu
client registry, check results, check execution history, and current
event data.

> Do check definitions need to exist on every system I wish to monitor?

**No.**  Check definitions can be written as publish/subscribe (pubsub) or standalone.
Pubsub checks, which specify a list of subscribers, need only be configured on
the Sensu server. Standalone checks, which are scheduled and executed by the
Sensu client, need only be configured on the client(s) where they should be run.

> Where should check plugin executables be installed?

Regardless of where checks are defined, the actual check executables need to
exist on the filesystem for the Sensu client to execute them. Check plugin
executables can be installed in `/etc/sensu/plugins` or
`/opt/sensu/embedded/bin`, the latter being the location where plugin
executables are installed via `sensu-install`.

> What is a standalone check?

A standalone check is a check definition that is installed on and executed by
the Sensu client without being scheduled by the Sensu server. Standalone checks
defer [Check execution scheduling
responsibilities](/overview/architecture/#check-execution-scheduler) to
Sensu clients, enabling decentralized management of monitoring checks and
distribution of scheduling responsibilities. Standalone checks may be used in
conjunction with pubsub checks, and are distinguished from pubsub checks by
inclusion of the `"standalone": true` configuration parameter.

> What happens if a single check is defined on both the Sensu server
<em>and</em> client?

When a check request is published for a check defined on the Sensu server, the
Sensu client will look for a local definition matching the check `name` prior to
executing the check. If a local definition exists, it is
[merged](/reference/configuration/#configuration-merging) with the
definition provided by the server, with any local definition attributes
overriding the definition provided by the Sensu server.

> What is Sensu Client safe_mode?

In `safe_mode` a client will not run a check published by a Sensu
server unless that check is also defined on the client. Safe mode must
be enabled on the Sensu Client via the `safe_mode` configuration
attribute.

> Can multiple Sensu servers be run concurrently, in a cluster?

**Yes.** Sensu is designed to be scaled horizontally (i.e. by
adding additional Sensu servers). It supports fully automated leader
election (ensuring that a single Sensu server acts as a centralized
[Check Execution Scheduler](/overview/architecture/#check-execution-scheduler)),
automated failover (automatically electing a new leader
if the previous leader is unexpectedly unavailable), and distributed
event processing (check results are distributed across all Sensu servers
in a round-robin fashion). Running more than one Sensu server is
highly recommended for performance and availability.

> How are new systems registered?

**Automatically.** Sensu clients register themselves when they
start up. The Sensu client process requires access to the [Sensu
Transport](/reference/transport/) (by default, this is
[RabbitMQ](/reference/rabbitmq/); see [Sensu
Configuration](/reference/configuration/#top-level-configuration-scopes)), and
some minimal client configuration (e.g. a `name`, `address`, and one or more
`subscriptions`) in order to start. When the Sensu client process starts, it
begins sending "keepalives" &ndash; a special type of check result containing
client configuration data &ndash; which the Sensu server uses to know that a
client is still connected. When a client keepalive is received for a client
`name` that is not currently registered with Sensu, the client is added to the
registry and a registration event is created automatically.

> Do system clocks need to be synchronized?

**Yes.** The Sensu services (i.e. sensu-client, sensu-server,
sensu-api, sensu-enterprise) use the local/system clock for generating
timestamps. When system clocks are out of sync between Sensu clients
(where data is collected) and the Sensu server (where data is
processed), Sensu may generate false positive client keepalive events,
among other potentially unexpected behaviors. Time synchronization can
be facilitated with [NTP](http://www.ntp.org/).

> Is Sensu Enterprise available as a hosted / SaaS solution?

**No.** Like Sensu Core, [Sensu Enterprise](/enterprise/overview/) is
installed on your organization's infrastructure alongside other applications and
services. Sensu Enterprise packages are available for major Linux distributions
including RHEL, CentOS, Debian and Ubuntu.

> Is Sensu available for Microsoft Windows?

**Yes.** An MSI installer package is available on the
[Downloads] page. Please visit the Sensu documentation for
more information on [configuring Sensu on
Windows](/platforms/sensu-on-microsoft-windows/).

> How do I increase log verbosity?

You can toggle debug logging on and off by sending the Sensu process a
`TRAP` signal.

For example:

~~~ bash
$ ps aux | grep [s]ensu-server
sensu     5992  1.7  0.3 177232 24352 ...
$ kill -TRAP 5992
~~~

[downloads]: https://sensuapp.org/downloads
