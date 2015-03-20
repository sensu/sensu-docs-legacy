---
version: 0.17
category: "Installation Guide"
title: "Install a Dashboard"
next:
  url: "installation-summary"
  text: "Installation Summary"
info:
warning:
danger:
---

# Overview

Sensu Core provides an API, enabling web dashboards to visualize Sensu data and provide additional functionality. Sensu Enterprise users have access to the Sensu Enterprise Dashboard, the official and supported web dashboard for Sensu. The Sensu community also provides several dashboard options, including the most commonly used Uchiwa dashboard.

The following instructions will help you to:

- [OPTIONAL] Install Uchiwa
- [OPTIONAL] Install Sensu Enterprise Dashboard

# Dashboards

## Uchiwa

The Uchiwa dashboard project provides its own installation and configuration guide. The guide can be found at [http://docs.uchiwa.io/en/latest/getting-started/](http://docs.uchiwa.io/en/latest/getting-started/).

## Sensu Enterprise Dashboard

### Install Sensu Enterprise Dashboard

_NOTE: access to the Sensu Enterprise repositories requires an active [Sensu Enterprise](http://sensuapp.org/enterprise#pricing) subscription, and valid access credentials._

The Sensu Enterprise Dashboard package is available via the [Sensu Enterprise Repositories](install-repositories#enterprise-installation).

### Ubuntu/Debian

~~~ shell
sudo apt-get update
sudo apt-get install sensu-enterprise-dashboard
~~~

### CentOS/RHEL

~~~ shell
sudo yum install sensu-enterprise-dashboard
~~~

### Configure Sensu Enterprise Dashboard

~~~ json
{
  "sensu": [
    {
      "name": "Datacenter 1",
      "host": "localhost",
      "port": 4567
    }
  ],
  "dashboard": {
    "host": "0.0.0.0",
    "port": 3000
  }
}
~~~
