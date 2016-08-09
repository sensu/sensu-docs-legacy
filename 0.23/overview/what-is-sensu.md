---
layout: "docs"
version: 0.23
weight: 1
title: "What is Sensu?"
next:
  url: "how-sensu-works.html"
  text: "Sensu Monitoring Flow"
---

# What is Sensu? {#what-is-sensu}

Sensu is an infrastructure and application monitoring and telemetry solution.
Sensu provides a framework for monitoring infrastructure, service & application
health, and business KPIs. Sensu is specifically designed to solve monitoring
challenges introduced by modern infrastructure platforms with a mix of static,
dynamic, and ephemeral infrastructure at scale (i.e. public, private, and hybrid
clouds).

Sensu allows organizations to compose comprehensive monitoring & telemetry
solutions to meet unique business requirements. By providing a platform to build
upon, Sensu enables you to focus on _what_ to monitor and measure, rather than
_how_. Sensu is installed on your organizations infrastructure &ndash; it is not
a Software-as-a-Service (SaaS) solution &ndash; which means Sensu gives you full
control over the availability of your monitoring solution.

## Benefits

Sensu is a comprehensive infrastructure and application monitoring solution that
provides the following benefits:

- **Monitor servers, services, application health, and business KPIs**

  Sensu is an infrastructure and application monitoring & telemetry solution.

- **Send alerts and notifications**

  Sensu integrates with the tools and services your organization is already
  using to do things like send emails, [PagerDuty][1] alerts, [Slack][2],
  [HipChat][3], IRC notifications, and [many][4] [more][5].

- **Dynamic client registration & de-registration**  

  When servers are provisioned, they automatically register themselves with
  Sensu, so there's no need to manually add or configure new servers.

- **A simple yet extensible model for monitoring**

  Sensu provides a sophisticated, yet simple to understand solution for
  executing [service checks][6] and [processing events][7] at scale. Service
  checks provide status and telemetry data, and event handlers process results.
  Hundreds of plugins are available for monitoring the tools and services you're
  already using. Plugins have a very simple specification, and can be written in
  any programming language.

- **Built for mission-critical applications and multi-tiered networks**

  Sensu's use of a [secure transport][8] protects your infrastructure from
  exposure and makes it possible for Sensu to traverse complex network
  topologies, including those that use NAT and VPNs, and span public networks.
  Sensu provides a secure monitoring solution trusted by international banking
  institutions, government agencies, Fortune 100 organizations, and many more.

- **Designed for automation**  

  Sensu exposes 100% of its configuration as JSON files, which makes it
  extremely automation&ndash;friendly (e.g. it was designed to work with tools
  like [Chef][9], [Puppet][10], and [Ansible][11]).

- **Open source software with commercial support**

  Sensu is an open-source software (OSS) project, made freely available under a
  permissive [MIT License][12] (the source code is publicly available
  on [GitHub][13]). [Sensu Enterprise][14] is based on
  Sensu Core (the OSS version of Sensu) which makes added-value features,
  commercial support, training, and many other benefits available under the
  [Sensu License][15].

## A Simple, Yet Powerful Framework

Sensu is a comprehensive monitoring solution that is powerful enough to solve
complex monitoring problems at scale, yet simple enough to use for traditional
monitoring scenarios and small environments. It achieves this broad appeal via
building upon two simple, yet powerful monitoring primitives: [Service
Checks][16] and [Event Processing][7]. These building blocks also provide an
infinitely extensible framework for composing monitoring solutions.

### What is a Service Check? {#service-checks}

Service checks allow you to monitor services (e.g. is Nginx running?) or measure
resources (e.g. how much disk space do I have left?). Service checks are
executed on machines running a monitoring agent (i.e. [Sensu client][17]).
Service checks are essentially commands (or scripts) that output data to
`STDOUT` or `STDERR` and produce an exit status code to indicate a state. Common
exit status codes used are 0 for OK, 1 for WARNING, 2 for CRITICAL, and 3 or
greater to indicate UNKNOWN or CUSTOM. Sensu checks use the same specification
as Nagios, therefore, Nagios check plugins may be used with Sensu. Service
checks produce results that are processed by the event processor (i.e. the Sensu
server).

[Learn more >][17]

### What is Event Processing? {#event-processing}

Event processing (also called stream processing) is a method of analyzing
(processing) and storing streams of information (data) about things that happen
(events), deriving a conclusion from them, and potentially executing some action
(handling). The Sensu event processor (the Sensu server) enables you to execute
[Handlers][18] for taking action on events (produced by service checks),
such as sending an email alert, creating or resolving an incident (e.g. in
PagerDuty or ServiceNow), or storing metric data in a time-series database (e.g.
Graphite).

[Learn more >][18]


[1]:  https://www.pagerduty.com
[2]:  https://slack.com
[3]:  http://www.hipchat.com
[4]:  /plugins
[5]:  /enterprise#built-in-integrations
[6]:  #service-checks
[7]:  #event-processing
[8]:  architecture.html#secure-transport
[9]:  http://www.chef.io
[10]: https://puppetlabs.com
[11]: http://www.ansible.com
[12]: https://github.com/sensu/sensu/blob/master/MIT-LICENSE.txt
[13]: http://github.com/sensu
[14]: https://sensuapp.org/enterprise
[15]: https://sensuapp.org/sensu-license
[16]: #service-checks
[17]: ../reference/clients.html
[18]: ../reference/handlers.html
