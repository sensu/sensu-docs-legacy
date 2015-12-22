---
version: 0.21
category: "Installation Guide"
title: "Install Sensu Client"
next:
  url: "install-a-dashboard"
  text: "Install a Dashboard"
success: "<strong>NOTE:</strong> this is part 5 of 6 steps in the Sensu
  Installation Guide. For the best results, please make sure to follow the
  instructions carefully and complete all of the steps in each section before
  moving on."
---

# Overview

Having successfully installed and configured Sensu, let's now configure a Sensu client. The Sensu client is run on every machine you need to monitor, including those running Sensu and its dependencies. The Sensu client is included in the Sensu Core package along with the Sensu server and API, but is not enabled by default.

The following instructions will help you to:

- Install and/or configure the Sensu client on the Sensu server (Sensu Core or Sensu Enterprise)
- **[OPTIONAL]** Install and configure the Sensu client on a separate machine


# Install the Sensu client

Good news - if you have been following the guide and have installed Sensu Core (even if your flavor of Sensu is Sensu Enterprise) - you have _already_ installed the Sensu client! As mentioned above, the Sensu client is included in the Sensu Core package, but not enabled by default.

However, if you are a Sensu Enterprise user and skipped installation of Sensu Core in the previous step of this guide, you will need to revisit those instructions and [install Sensu Core](install-sensu#install-sensu-core).


## Configure the Sensu client

Each Sensu client requires its own client definition, containing a set of required attributes (name, address, subscriptions). To configure the Sensu client, copy the following example configuration to `/etc/sensu/conf.d/client.json` manually, or via:

~~~ shell
sudo wget -O /etc/sensu/conf.d/client.json http://sensuapp.org/docs/0.21/files/client.json
~~~

_NOTE: this example file configures the Sensu client with client metadata, including a unique name, an address (any string), and its [Sensu Subscriptions](clients#what-are-sensu-clients)._

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

Ensure the Sensu configuration files are owned by the Sensu user and group `sensu`:

~~~ shell
sudo chown -R sensu:sensu /etc/sensu
~~~

## Install Check Dependencies

Some Sensu [Checks](checks) have dependencies that are required for execution (e.g. local copies of check plugins/scripts). Earlier in the guide, we configured a monitoring check called `disk`, that runs the command `check-disk-usage.rb`. Each Sensu client that will execute the `disk` check will require a local copy of this file. To install the Sensu plugin that includes a copy of `check-disk-usage.rb`, run the following commands:

~~~ shell
sudo sensu-install -p disk-checks:1.0.2
~~~

## Running the Sensu client

Now that the Sensu client has been configured and local check dependencies (i.e. the plugins and any plugin dependencies such as Ruby) have been installed, we're ready to start the Sensu client.

~~~ shell
sudo /etc/init.d/sensu-client start
~~~

## Observe the Sensu client

Congratulations! By now you should have successfully installed and configured the Sensu client! Now let's observe it in operation.

_NOTE: the check requests for "disk" are being published every 10 seconds, so it should be possible to observe log activity (i.e. the check requests) at least once every 10 seconds._

Tail the Sensu client log file to observe its operation:

~~~ shell
sudo tail -f /var/log/sensu/sensu-client.log
~~~

# Enable Sensu on boot

By default, the Sensu client service does not start on boot. Use the following instructions to enable/start Sensu client on boot.

## Ubuntu/Debian

~~~ shell
sudo update-rc.d sensu-client defaults
~~~

## CentOS/RHEL

~~~ shell
sudo chkconfig sensu-client on
~~~

# Install the Sensu client on remote hosts

## Overview

Configuring the Sensu client on remote hosts works much the same as the previous steps in this guide. The primary difference is that Sensu clients installed on remote hosts will need to be able to traverse the network to communicate with the transport (by default, this is the RabbitMQ service).

The following instructions will help you to:

- Install the Sensu Core repository
- Install & configure the Sensu client (including RabbitMQ connection configuration)

## Install the Sensu Core repository

Please see: [Install the Sensu Core Repository](install-repositories#install-the-sensu-core-repository)

## Install Sensu Core

Please see: [Install Sensu Core](install-sensu#install-sensu-core)

## Configure the Sensu client

As discussed earlier in this guide, all Sensu services use a transport (by default, this is RabbitMQ) to communicate with one another. In order for our Sensu client to communicate with the transport, we need to tell it where to find the transport. Just like we did previously in this guide for [the other Sensu services](install-sensu#configure-connections), we need to create the primary configuration file for Sensu by copying the following contents to `/etc/sensu/config.json` (replacing `YOUR_RABBITMQ_HOST_IP` with the IP address of your RabbitMQ machine):

~~~ json
{
  "rabbitmq": {
    "host": "YOUR_RABBITMQ_HOST_IP",
    "vhost": "/sensu",
    "user": "sensu",
    "password": "secret"
  },
  "client": {
    "name": "localhost",
    "address": "127.0.0.1",
    "subscriptions": [
      "test"
    ]
  }
}
~~~

## Running & observing the Sensu client

Please refer to the instructions found above for [running the Sensu client](#running-the-sensu-client) and [observing the Sensu client](#observe-the-sensu-client)
