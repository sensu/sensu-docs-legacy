---
version: 0.17
category: "Installation Guide"
title: "Install Sensu Client"
next:
  url: "install-a-dashboard"
  text: "Install a Dashboard"
info:
warning:
danger:
---

# Overview

Having successfully installed and configured Sensu, let's now configure a Sensu client. The Sensu client is run on every machine you need to monitor, including those running Sensu and its dependencies. The Sensu client is included in the Sensu Core package, but not enabled by default. 

The following instructions will help you to:

- Install and/or configure the Sensu client on the Sensu server (Sensu Core or Sensu Enterprise)
- [OPTIONAL] Install and configure the Sensu client on a separate machine


# Install the Sensu client

Good news - if you have been following the guide and have installed Sensu Core (even if your flavor of Sensu is Sensu Enterprise) - you have _already_ installed the Sensu client! As mentioned above, the Sensu client is included in the Sensu Core package, but not enabled by default. 

However, if you are a Sensu Enterprise user and skipped installation of Sensu Core in the previous step of this guide, you will need to revisit those instructions and [install Sensu Core](install-sensu#install-sensu-core). 


# Configure the Sensu client

Each Sensu client requires its own client definition, containing a set of required attributes (name, address, subscriptions). To configure the Sensu client, copy the following example configuration to `/etc/sensu/conf.d/client.json` manually, or via:

~~~ shell
sudo wget -O /etc/sensu/conf.d/client.json http://sensuapp.org/docs/0.17/files/client.json
~~~

_NOTE: this example file configures the Sensu client with client metadata, including a unique name, an address (any string), and its [Sensu Subscriptions]()._

~~~ shell
{
  "client": {
    "name": "test",
    "address": "localhost",
    "subscriptions": [
      "test"
    ]
  }
}
~~~

# Install Check Dependencies

Some Sensu [Checks](checks) have dependencies that are required for execution (e.g. local copies of check plugins/scripts).  

~~~ shell
sudo wget -O /etc/sensu/plugins/check-mem.sh http://sensuapp.org/docs/0.17/files/check-mem.sh
sudo chmod +x /etc/sensu/plugins/check-mem.sh
~~~

Ensure the Sensu configuration files and plugins are owned by the Sensu user and group `sensu`:

~~~ shell
sudo chown -R sensu:sensu /etc/sensu
~~~



# Running the Sensu client






## Ubuntu/Debian



## CentOS/RHEL



# Install on the same machine

## Configure


# Observing


# Install on a separate machine

- install the Sensu Core repository
- install the Sensu package







