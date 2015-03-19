---
version: 0.17
category: "Installation Guide"
title: "Install Sensu"
next:
  url: "install-sensu-client"
  text: "Install Sensu Client"
---

# Overview

Having successfully completed installation of Sensu's dependencies ([RabbitMQ](install-rabbitmq), and [Redis](install-redis)) and the [Sensu Repositories](install-repositories), we are now ready to install Sensu! Instructions are provided for installing both flavors of Sensu (Sensu Core and Sensu Enterprise). 

_NOTE: Sensu Core and Sensu Enterprise may be installed alongside one another, however only one flavor of Sensu should be run at any given time (see [below](#running-sensu) for more info)._ 

# Install Sensu

## Sensu Core {#install-sensu-core}

Install Sensu Core from the Sensu repository:

### Ubuntu/Debian

~~~ shell
sudo apt-get update
sudo apt-get install sensu
~~~

### CentOS/RHEL

~~~ shell
sudo yum install sensu
~~~

## Sensu Enterprise {#install-sensu-enterprise}

Install Sensu Enterprise from the Sensu Enterprise repository:

_NOTE: access to the Sensu Enterprise repositories requires an active [Sensu Enterprise](http://sensuapp.org/enterprise#pricing) subscription, and valid access credentials._

### Ubuntu/Debian

~~~ shell
sudo apt-get update
sudo apt-get install sensu-enterprise
~~~

### CentOS/RHEL

~~~ shell
sudo yum install sensu-enterprise
~~~

# Configure Sensu

## Configure Connections

The primary configuration for Sensu is stored in JSON format at `/etc/sensu/config.json`. To configure the Sensu services, copy the following example configuration to `/etc/sensu/config.json` manually, or via:

~~~ shell
sudo wget -O /etc/sensu/config.json http://sensuapp.org/docs/0.17/files/config.json
~~~

_NOTE: this example file configures the RabbitMQ and Redis connection options._

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
  }
}
~~~

## Configure a Check

Sensu Checks & Event Handlers will be covered in detail later in this guide, however it will be helpful to have at least one check and handler configured as part of the installation process. If you don't fully understand these concepts - don't worry - we'll explain later. 

Create a check definition by copying the following example configuration to `/etc/sensu/conf.d/check_memory.json` manually, or via:

~~~ shell
sudo wget -O /etc/sensu/conf.d/check_memory.json http://sensuapp.org/docs/0.17/files/check_memory.json
~~~

_NOTE: this example config creates a [Sensu Check]() that will alert based on memory thresholds (it will raise a warning if less than 128 MB of memory is available, and raise a critical alert if less than 64 MB of memory is available)._

~~~ json
{
  "checks": {
    "memory": {
      "command": "/etc/sensu/plugins/check-mem.sh -w 128 -c 64",
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
sudo wget -O /etc/sensu/conf.d/default_handler.json http://sensuapp.org/docs/0.17/files/default_handler.json
~~~

_NOTE: this example config creates a [Sensu Event Handler]() that will be used by default for Sensu events that do not specify a handler._

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

# Running Sensu

Only one flavor of Sensu should be used at any given time: Sensu Core (sensu-server + sensu-api), or Sensu Enterprise. If you have previously run Sensu Core or Sensu Enterprise and are switching flavors, simply stop one and start the other. 

## Sensu Core

~~~ shell
sudo /etc/init.d/sensu-server start
sudo /etc/init.d/sensu-api start
~~~

## Sensu Enterprise

~~~ shell
sudo /etc/init.d/sensu-enterprise start
~~~

# Observe Sensu

Congratulations! By now you should have successfully installed and configured Sensu! Now let's observe it in operation. 

## Sensu Core

Tail the Sensu Core server and API log files to observe their operation:

Sensu Core server logs:

_NOTE: the check requests for "memory" being published every 10 seconds._

~~~ shell
sudo tail -f /var/log/sensu/sensu-server.log
~~~

Sensu Core API logs:

~~~ shell
sudo tail -f /var/log/sensu/sensu-api.log
~~~

## Sensu Enterprise

By default, Sensu Enterprise only logs at "WARN" log level. To temporarily view more log activity, we'll need to toggle the debug log level for Sensu Enterprise:

~~~ shell
sudo kill -TRAP `cat /var/run/sensu-enterprise.pid`
~~~

Tail the Sensu Enterprise log file to observe its operation:

_NOTE: the check requests for "memory" being published every 10 seconds._

~~~ shell
sudo tail -f /var/log/sensu-enterprise.log
~~~
