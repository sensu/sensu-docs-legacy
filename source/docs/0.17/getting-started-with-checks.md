---
version: 0.17
category: "Getting Started Guide"
title: "Getting Started with Checks"
next:
  url: "getting-started-with-handlers"
  text: "Getting Started with Handlers"
---

# Overview

The purpose of this guide is to help Sensu users create monitoring checks. At the conclusion of this guide, you - the user - should have several Sensu checks in place to monitor and measure machine resources. Each Sensu monitoring check in this guide demonstrates one or more check definition features, for more information please refer to the [checks reference documentation](checks).

## Objectives

What will be covered in this guide:

- Creation of **standard** checks (functional tests)
- Creation of a **metric** collection checks (machine resource, etc.)

# What are Sensu checks? {#what-are-sensu-checks}

Sensu checks allow you to monitor services or measure resources, they are executed on servers running the Sensu client. Checks are essentially commands (or scripts) that output data to `STDOUT` or `STDERR` and produce an exit status code to indicate a state. Common exit status codes used are `0` for `OK`, `1` for `WARNING`, `2` for `CRITICAL`, and `3` or greater to indicate `UNKNOWN` or `CUSTOM`. Sensu checks use the same specification as Nagios, therefore, Nagios check plugins may be used with Sensu.

# Create a standard check

Standard Sensu checks are used to determine the current health of machine resources and services. A standard check will query a resource for information to determine its state. Once a standard check has determined the resource state, it outputs a human readable message, and exits with the appropriate exit status code to indicate its state/severity (OK, WARNING, etc.).

## Monitor the cron service

The following instructions install the check dependencies and configure the Sensu check definition in order to monitor the Cron service.

### Install dependencies

The following instructions install the `check-procs` Sensu plugin (written in Ruby) to `/etc/sensu/plugins/check-procs.rb`. This Sensu plugin can reliably detect if a service, like Cron, is running or not.

~~~ shell
sudo wget -O /etc/sensu/plugins/check-procs.rb http://sensuapp.org/docs/0.17/files/check-procs.rb
sudo chmod +x /etc/sensu/plugins/check-procs.rb
~~~

The `check-procs` Sensu plugin requires a Ruby runtime and the `sensu-plugin` Ruby gem. Install Ruby from the distribution repository and `sensu-plugin` from Rubygems:

_NOTE: the following Ruby installation steps may differ depending on your platform_

#### Ubuntu/Debian

~~~ shell
sudo apt-get update
sudo apt-get install ruby ruby-dev
sudo gem install sensu-plugin
~~~

#### CentOS/RHEL

~~~ shell
sudo yum install ruby ruby-devel
sudo gem install sensu-plugin
~~~

### Create the check definition for Cron

The following is an example Sensu check definition, a JSON configuration file located at `/etc/sensu/conf.d/check_cron.json`. This check definition uses the [check-procs plugin](#install-dependencies) to determine if the Cron service is running. The check is named `cron` and it runs `/etc/sensu/plugins/check-procs.rb -p cron` on Sensu clients with the `production` subscription, every `60` seconds (interval).

~~~ json
{
  "checks": {
    "cron": {
      "command": "/etc/sensu/plugins/check-procs.rb -p cron",
      "subscribers": [
        "production"
      ],
      "interval": 60
    }
  }
}
~~~

For a full listing of the `check-procs` command line arguments, run `/etc/sensu/plugins/check-procs.rb -h`.

Currently, the Cron check definition requires that check requests be sent to Sensu clients with the `production` subscription. This is known as **check subscription mode**. Optionally, a check may use `standalone` mode, which allows clients to schedule their own check executions. The following is an example of the Cron check using `standalone` mode (true). The Cron check will now be executed every `60` seconds on each Sensu client with the check definition. A Sensu check definition with `"standalone": true` does not need to specify `subscribers`.

~~~ json
{
  "checks": {
    "cron": {
      "command": "/etc/sensu/plugins/check-procs.rb -p cron",
      "standalone": true,
      "interval": 60
    }
  }
}
~~~

By default, Sensu checks use the `default` Sensu event handler for events they create. To specify a different Sensu event handler for a check, use the `handler` attribute.

~~~ json
{
  "checks": {
    "cron": {
      "command": "/etc/sensu/plugins/check-procs.rb -p cron",
      "standalone": true,
      "interval": 60,
      "handler": "email"
    }
  }
}
~~~

To specify multiple Sensu event handlers, us the `handlers` attribute.

~~~ json
{
  "checks": {
    "cron": {
      "command": "/etc/sensu/plugins/check-procs.rb -p cron",
      "standalone": true,
      "interval": 60,
      "handlers": ["pagerduty", "email"]
    }
  }
}
~~~

# Create a metric collection check

## Monitor CPU utilization

## Monitor memory utilization






A service stat that monitors a service (e.g. memcached) by
attempting to interact with the service or application (e.g. querying or sending
data to a specific port on a node and evaluating the response). Functional
checks are particularly useful because they verify that applications and
services are functioning as desired. Where possible, functional monitoring check
coverage should be implemented for the same functions as source code unit tests.

 demonstrate checking the state of an application or system service. If the service is running, the check will exit with a status of 0 (OK). If the service is not running, the check will exit with a status of 1 (WARNING).


## 3.2. Sensu Checks

[32]: #32-sensu-checks

Source: [Sensu Check Definitions]()

The Echelon monitoring solution is built on top of the [Sensu][sensu] open
source monitoring framework and the [Flapjack][flapjack] monitoring notification
routing and event processing system.

Sensu [checks][sensu-checks] are used for service monitoring (i.e. "service
checks") and resource measurement (i.e. "metric checks"). The Sensu check
definitions are stored in [Chef][chef] [data bags][chef-data-bags] as referenced
above (Source). Each check has the following attributes:

- `id`
  A unique and usually descriptive identifier or name (e.g. "memcached_socket")

- `command`
  The command that will be executed on the corresponding client(s). These
  commands may be common system utility commands (e.g. `ps`), Sensu plugins (
  see [Sensu Community Plugins][sensu-community-plugins]), or even Nagios
  plugins (see
  [Sensu Nagios Plugin Compatibility][sensu-nagios-plugin-compatibility]).
  _NOTE: the `command` contents will commonly include parameters for setting
  "warning" (`-w`) and "critical" (`-c`) thresholds; knowing this can help you
  understand when a Sensu check will trigger an alert (or other event handler);
  for example a check `command` with the parameters `-w 85 -c 95` probably means
  "warn at 85%, critical at 95%"._

- `notification`
  A brief description of the check and and/or explanation of what a failure \
  means (e.g. "memcached socket is not responding"). This content is included
  in any notifications that are sent. _NOTE: there are plans to incorporate
  links to support documentation in email notifications to provide context and
  helpful information in the event of an alert; these links would be included
  in the Sensu check `notification` content._

- `subscribers`
  Sensu [clients][sensu-clients] are configured to "subscribe" to queues where
  the Sensu Server will publish check requests. This parameter defines which
  subscriptions (and thus, which roles/nodes) will execute this check.

- `interval`
  How frequently (in seconds) the check will be executed.

## 3.3. Check & Alert Types

[33]: #33-check--alert-types

Sensu checks can be used for _Monitoring_ services **and** for collecting
_Metrics_. While there are not formal check "types" in Sensu, it is considered
a best practice to combine different styles of monitoring and metrics checks, as
follows:

- Monitoring
  - Functional Monitoring Checks
  - Informational Monitoring Checks
- Metrics
  - Metrics Collection Checks
  - Metrics Analysis Checks

### 3.3.1. Functional Monitoring Checks

[331]: #332-functional-monitoring-checks

A [Sensu check][sensu-checks] that monitors a service (e.g. memcached) by
attempting to interact with the service or application (e.g. querying or sending
data to a specific port on a node and evaluating the response). Functional
checks are particularly useful because they verify that applications and
services are functioning as desired. Where possible, functional monitoring check
coverage should be implemented for the same functions as source code unit tests.

_EXAMPLE(S): [solr_http]() (uses
[check-http.rb][sensu-check-http.rb]),
[zookeeper_socket]() (uses
[check-banner.rb][sensu-check-banner.rb])._

### 3.3.2. Informational Monitoring Checks

[332]: #331-information-monitoring-checks

A [Sensu check][sensu-checks] that monitors a service (e.g. memcached) by
looking for a process id file, or a running process matching a specified name is
an informational check.

_EXAMPLE(S): [solr_process]() (uses
[check-procs.rb][sensu-check-procs.rb]),
[zookeeper_process]() (uses
[checks-procs.rb][sensu-check-procs.rb])._

### 3.3.3. Metrics Collection Checks

[333]: #333-metrics-collection-checks

A [Sensu check][sensu-checks] that measures data and reports the result is a
"metrics collection" check. No alerts are generated for metrics collection
checks - they are only used for collecting data and/or shipping data to a metric
store (e.g. [Graphite][graphite]) which metric store(s) may be further analyzed
by a [Metrics Analysis Check][334] (which check(s) may result in alerts).

_EXAMPLE(S): [disk_usage_metrics]() (uses
[disk-usage-metrics.rb][sensu-disk-usage-metrics.rb]),
[solr_metrics]() (uses
[solr4-graphite.rb][sensu-solr4-graphite.rb])._

### 3.3.4. Metrics Analysis Checks

[334]: #334-metrics-analysis-checks

A [Sensu check][sensu-checks] that analyzes metric data is called a "metrics
analysis check" (which data may or may not have been collected by a
[Metrics Analysis Check][333]). Metrics analysis checks may interact with nodes,
or with a metric store (e.g. [Graphite][graphite]) to perform queries and/or
other data evaluations.

_EXAMPLE(S): [disk_usage]() (uses
[check-data.rb][sensu-check-data.rb])._

[sensu]: http://sensuapp.org
[sensu-checks]: http://sensuapp.org/docs/latest/checks
[sensu-clients]: http://sensuapp.org/docs/latest/clients
[sensu-community-plugins]: https://github.com/sensu/sensu-community-plugins
[sensu-nagios-plugin-compatibility]: http://sensuapp.org/docs/latest/checks#what-are-checks
[flapjack]: http://flapjack.io
[chef]: http://getchef.com
[chef-data-bags]: https://docs.getchef.com/essentials_data_bags.html
[graphite]: http://graphite.wikidot.com/
[sensu-check-data.rb]: https://github.com/sensu/sensu-community-plugins/blob/master/plugins/graphite/check-data.rb
[sensu-disk-usage-metrics.rb]: https://github.com/sensu/sensu-community-plugins/blob/master/plugins/system/disk-usage-metrics.rb
[sensu-solr4-graphite.rb]: https://github.com/sensu/sensu-community-plugins/blob/master/plugins/solr/solr4-graphite.rb
[sensu-check-http.rb]: https://github.com/sensu/sensu-community-plugins/blob/master/plugins/http/check-http.rb
[sensu-check-banner.rb]: https://github.com/sensu/sensu-community-plugins/blob/master/plugins/network/check-banner.rb
[sensu-check-procs.rb]: https://github.com/sensu/sensu-community-plugins/blob/master/plugins/processes/check-procs.rb
