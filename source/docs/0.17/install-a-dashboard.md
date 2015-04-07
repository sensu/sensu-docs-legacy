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
In /etc/sensu/dashboard.json

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

### Running Sensu Enterprise Dashboard

~~~ shell
sudo /etc/init.d/sensu-enterprise-dashboard start
~~~

### Observing the Sensu Enterprise Dashboard logs

Congratulations! By now you should have successfully installed and configured Sensu Enterprise Dashboard! Now let's observe it in operation.

Tail the Sensu Enterprise Dashboard log file to observe its operation:

~~~ shell
sudo tail -f /var/log/sensu/sensu-enterprise-dashboard.log
~~~

If Sensu Enterprise Dashboard started successfully you should notice a line containing:

~~~
now listening on 0.0.0.0:3000
~~~

### Viewing Sensu Enterprise Dashboard

Now that Sensu Enterprise Dashboard is up and running, you can view the dashboard at `http://<DASHBOARD_IP_ADDRESS>:3000`.
