---
version: 0.22
category: "Installation Guide"
title: "Install Sensu"
next:
  url: "install-sensu-client"
  text: "Install Sensu Client"
success: "<strong>NOTE:</strong> this is part 4 of 6 steps in the Sensu
  Installation Guide. For the best results, please make sure to follow the
  instructions carefully and complete all of the steps in each section before
  moving on."
---

# Install Sensu

Having successfully completed installation of Sensu's dependencies ([RabbitMQ](install-rabbitmq), and [Redis](install-redis)) and the [Sensu Repositories](install-repositories), we are now ready to install Sensu!

This guide will help you to:

- Install Sensu Core
- Install Sensu Enterprise

_NOTE: Sensu Core and Sensu Enterprise may be installed alongside one another, however only one flavor of Sensu should be run at any given time (see [below](#running-sensu) for more info)._

## Install Sensu

### Sensu Core {#install-sensu-core}

Install Sensu Core from the Sensu repository:

#### Ubuntu/Debian

~~~ shell
sudo apt-get update
sudo apt-get install sensu
~~~

#### CentOS/RHEL

~~~ shell
sudo yum install sensu
~~~

### Sensu Enterprise {#install-sensu-enterprise}

Install Sensu Enterprise from the Sensu Enterprise repository:

_NOTE: access to the Sensu Enterprise repositories requires an active [Sensu Enterprise](http://sensuapp.org/enterprise#pricing) subscription, and valid access credentials._

#### Ubuntu/Debian

~~~ shell
sudo apt-get update
sudo apt-get install sensu-enterprise
~~~

#### CentOS/RHEL

~~~ shell
sudo yum install sensu-enterprise
~~~

## Configure Sensu

### Configure Connections

The primary configuration for Sensu is stored in JSON format at `/etc/sensu/config.json`. To configure the Sensu services, copy the following example configuration to `/etc/sensu/config.json` manually, or via:

~~~ shell
sudo wget -O /etc/sensu/config.json http://sensuapp.org/docs/0.22/files/config.json
~~~

_NOTE: this example file configures the RabbitMQ and Redis connection options and the Sensu API._

~~~ json
{
  "rabbitmq": {
    "host": "localhost",
    "vhost": "/sensu",
    "user": "sensu",
    "password": "secret"
  },
  "redis": {
    "host": "localhost"
  },
  "api": {
    "host": "localhost",
    "port": 4567
  }
}
~~~

### Configure a Check

Sensu Checks & Event Handlers will be covered in detail later in this guide, however it will be helpful to have at least one check and handler configured as part of the installation process. If you don't fully understand these concepts - don't worry - we'll explain later.

Create a check definition by copying the following example configuration to `/etc/sensu/conf.d/check_disk.json` manually, or via:

~~~ shell
sudo wget -O /etc/sensu/conf.d/check_disk.json http://sensuapp.org/docs/0.22/files/check_disk.json
~~~

_NOTE: this example config creates a [Sensu Check](checks) that will alert based on disk usage thresholds (it will raise a critical alert if 95% or more disk space has been used, or raise a warning alert if 85% or more has been used). The check script itself (the plugin) will be installed later in this guide._

~~~ json
{
  "checks": {
    "disk": {
      "command": "check-disk-usage.rb -w 85 -c 95",
      "interval": 10,
      "subscribers": [
        "test"
      ]
    }
  }
}
~~~

Create a default handler definition by copying the following example configuration to `/etc/sensu/conf.d/default_handler.json` manually, or via:

~~~ shell
sudo wget -O /etc/sensu/conf.d/default_handler.json http://sensuapp.org/docs/0.22/files/default_handler.json
~~~

_NOTE: this example config creates a [Sensu Event Handler](handlers) that will be used by default for Sensu events that do not specify a handler._

~~~ json
{
  "handlers": {
    "default": {
      "type": "pipe",
      "command": "cat"
    }
  }
}
~~~

Ensure the Sensu configuration files are owned by the Sensu user and group `sensu`:

~~~ shell
sudo chown -R sensu:sensu /etc/sensu
~~~

## Running Sensu

_NOTE: Only **one** flavor of Sensu should be used at any given time: Sensu Core (sensu-server + sensu-api), or Sensu Enterprise. If you have previously run Sensu Core or Sensu Enterprise and are switching flavors, simply stop one and start the other._

### Sensu Core

~~~ shell
sudo /etc/init.d/sensu-server start
sudo /etc/init.d/sensu-api start
~~~

### Sensu Enterprise

~~~ shell
sudo /etc/init.d/sensu-enterprise start
~~~

## Observe Sensu

Congratulations! By now you should have successfully installed and configured Sensu! Now let's observe it in operation.

_NOTE: the check requests for "disk" are being published every 10 seconds, so it should be possible to observe log activity (i.e. the check requests) at least once every 10 seconds._

### Sensu Core

Tail the Sensu Core server and API log files to observe their operation:

Sensu Core server logs:

~~~ shell
sudo tail -f /var/log/sensu/sensu-server.log
~~~

Sensu Core API logs:

~~~ shell
sudo tail -f /var/log/sensu/sensu-api.log
~~~

### Sensu Enterprise

By default, Sensu Enterprise only logs at "WARN" log level. To temporarily view more log activity, we'll need to toggle the debug log level for Sensu Enterprise:

~~~ shell
sudo kill -TRAP `cat /var/run/sensu-enterprise.pid`
~~~

Tail the Sensu Enterprise log file to observe its operation:

~~~ shell
sudo tail -f /var/log/sensu/sensu-enterprise.log
~~~

## Enable Sensu on boot

By default, the Sensu Core services and Sensu Enterprise do not start on boot. Use the following instructions to enable/start your flavor of Sensu on boot.

_NOTE: Only **one** flavor of Sensu should be used at any given time: Sensu Core (sensu-server + sensu-api), or Sensu Enterprise. If you have previously enabled Sensu Core or Sensu Enterprise on boot and are switching flavors, simply stop and disable one and enable the other._

### Sensu Core

#### Ubuntu/Debian

~~~ shell
sudo update-rc.d sensu-server defaults
sudo update-rc.d sensu-api defaults
~~~

#### CentOS/RHEL

~~~ shell
sudo chkconfig sensu-server on
sudo chkconfig sensu-api on
~~~

### Sensu Enterprise

#### Ubuntu/Debian

~~~ shell
sudo update-rc.d sensu-enterprise defaults
~~~

#### CentOS/RHEL

~~~ shell
sudo chkconfig sensu-enterprise on
~~~
