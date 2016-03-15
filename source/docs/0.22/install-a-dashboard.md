---
version: 0.22
category: "Installation Guide"
title: "Install a Dashboard"
next:
  url: "installation-summary"
  text: "Installation Summary"
success: "<strong>NOTE:</strong> this is part 6 of 6 steps in the Sensu
  Installation Guide. For the best results, please make sure to follow the
  instructions carefully and complete all of the steps in each section before
  moving on."
---

# Install a Dashboard

Sensu Core provides an API, enabling web dashboards to visualize Sensu data and provide additional functionality. The official, community supported dashboard for Sensu is called [Uchiwa](http://uchiwa.io). Sensu Enterprise users have access to the Sensu Enterprise Dashboard, the official dashboard for Sensu Enterprise.

_NOTE: installation and use of a dashboard is not required for operating Sensu Core or Sensu Enterprise._

The following instructions will help you to:

- **[OPTIONAL]** Install Uchiwa
- **[OPTIONAL]** Install Sensu Enterprise Dashboard

## Dashboards

### Uchiwa

The Uchiwa dashboard project provides its own installation and configuration guide. The guide can be found at [http://docs.uchiwa.io/en/latest/getting-started/](http://docs.uchiwa.io/en/latest/getting-started/).

### Sensu Enterprise Dashboard

#### Install Sensu Enterprise Dashboard

_NOTE: access to the Sensu Enterprise repositories requires an active [Sensu Enterprise](http://sensuapp.org/enterprise#pricing) subscription, and valid access credentials._

The Sensu Enterprise Dashboard package is available via the [Sensu Enterprise Repositories](install-repositories#enterprise-installation).

#### Ubuntu/Debian

~~~ shell
sudo apt-get update
sudo apt-get install sensu-enterprise-dashboard
~~~

#### CentOS/RHEL

~~~ shell
sudo yum install sensu-enterprise-dashboard
~~~

#### Configure Sensu Enterprise Dashboard

To configure the Sensu Enterprise Dashboard, copy the following example configuration to `/etc/sensu/dashboard.json` manually, or via:

~~~ shell
sudo wget -O /etc/sensu/dashboard.json http://sensuapp.org/docs/0.22/files/dashboard.json
~~~

_NOTE: this example file configures the Sensu Enterprise Dashboard with a list of Sensu Enterprise API endpoints (the Sensu Enterprise Dashboard can be used with multiple Sensu Enterprise installations), and the hostname and port the dashboard will listen on. For more details about Sensu Enterprise Dashboard configuration, please see: [Sensu Enterprise Dashboard Docs](enterprise-dashboard-overview)_

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

#### Running Sensu Enterprise Dashboard

To start the Sensu Enterprise dashboard, please run the following command:

~~~ shell
sudo /etc/init.d/sensu-enterprise-dashboard start
~~~

#### Observing the Sensu Enterprise Dashboard logs

Congratulations! By now you should have successfully installed and configured Sensu Enterprise Dashboard! Now let's observe it in operation.

Tail the Sensu Enterprise Dashboard log file to observe its operation:

~~~ shell
sudo tail -f /var/log/sensu/sensu-enterprise-dashboard.log
~~~

If Sensu Enterprise Dashboard started successfully you should notice a line containing:

~~~
now listening on 0.0.0.0:3000
~~~

#### Viewing Sensu Enterprise Dashboard

Now that Sensu Enterprise Dashboard is up and running, you can view the dashboard at `http://<DASHBOARD_IP_ADDRESS>:3000`.

_NOTE: Multiple Sensu Enterprise Dashboard instances can be installed. When load balancing across multiple Dashboard instances, your load balancer should support 'sticky sessions'._
