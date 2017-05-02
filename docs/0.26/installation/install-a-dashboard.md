---
title: "Sensu Dashboards"
version: 0.26
weight: 6
next:
  url: "summary.html"
  label: "Installation Summary"
---

# Install a Sensu Dashboard

Sensu was originally designed as an API-based monitoring solution, enabling
operations teams to compose monitoring solutions where Sensu provides the
monitoring instrumentation, collection of telemetry data, scalable event
processing, comprehensive APIs &ndash; _and plugins for sending data to
dedicated dashboard solutions_. However, as the Sensu Core project and community
have matured, the need for an optional Sensu dashboard has become more obvious.
As a result, there are now two (2) dashboard solutions for Sensu: **Uchiwa**
(for Sensu Core users), and the **Sensu Enterprise Dashboard** (for [Sensu
Enterprise][sensu-enterprise] customers).

Both Uchiwa and the Sensu Enterprise Dashboard work by accessing data directly
via the Sensu APIs (i.e. the [Sensu Core APIs][core-api], or the [Sensu
Enterprise APIs][enterprise-api]).

- [Install Sensu Enterprise Dashboard on Ubuntu/Debian](../platforms/sensu-on-ubuntu-debian.html#sensu-enterprise)
- [Install Sensu Enterprise Dashboard on RHEL/CentOS](../platforms/sensu-on-rhel-centos.html#sensu-enterprise)

To install Uchiwa, please visit the [Getting Started with
Uchiwa][uchiwa-install] guide, on the [Uchiwa website](http://uchiwa.io).

_NOTE: as mentioned above &ndash; installation and use of a dashboard is not
required for operating Sensu Core or Sensu Enterprise._

[sensu-enterprise]:       https://sensuapp.org/enterprise
[core-api]:               ../api/overview.html
[enterprise-api]:         ../enterprise/api.html
[uchiwa-install]:         http://docs.uchiwa.io/getting-started/
