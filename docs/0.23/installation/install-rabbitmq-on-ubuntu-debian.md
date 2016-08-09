---
title: "Install RabbitMQ on Ubuntu/Debian"
description: "The complete Sensu installation guide."
version: 0.23
weight: 0
hidden: true
next:
  url: "install-sensu-server-api.html"
  text: "Install the Sensu Server & API"
---

# Install RabbitMQ on Ubuntu/Debian

- [Install Erlang (the RabbitMQ runtime)](#install-erlang)
- [Install RabbitMQ](#install-rabbitmq)
  - [Download and install RabbitMQ using `dpkg` (recommended)](#download-and-install-rabbitmq-using-dpkg)
  - [Install RabbitMQ using APT](#install-rabbitmq-using-apt)
- [Managing the RabbitMQ service/process](#managing-the-rabbitmq-serviceprocess)
- [Configure RabbitMQ access controls](#configure-rabbitmq-access-controls)
- [Configure system limits on Linux](#configure-system-limits-on-linux)
- [Configure Sensu](#configure-sensu)
  - [Example standalone configuration](#example-standalone-configuration)
  - [Example distributed configuration](#example-distributed-configuration)

## Install Erlang (the RabbitMQ runtime) {#install-erlang}

RabbitMQ runs on the [Erlang runtime][1], so before you can install and run
RabbitMQ, you'll need to install Erlang.

1. Add the Erlang Solutions APT repository

   ~~~ shell
   sudo wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
   sudo dpkg -i erlang-solutions_1.0_all.deb
   sudo apt-get update
   ~~~

2. Install Erlang

   ~~~ shell
   sudo apt-get -y install erlang-nox=1:18.2
   ~~~

## Install RabbitMQ

According to the [official RabbitMQ installation guide][2], although RabbitMQ
packages are included in the Ubuntu and Debian distribution repositories,
downloading and installing RabbitMQ from the RabbitMQ website is the recommended
installation method.

> `rabbitmq-server` is included in Debian since 6.0 (squeeze) and in Ubuntu
  since 9.04. However, the versions included are often quite old. You will
  _probably_ get better results installing the `.deb` from our website. Check
  the Debian package and Ubuntu package details for which version of the server
  is available for which versions of the distribution.

[Sensu Support][3] is available for RabbitMQ versions 3.6.0 and newer ([on
Erlang version R16B03 or newer][4]).

### Download and install RabbitMQ using `dpkg`

1. Download the official RabbitMQ 3.6.0 .deb installer package, as suggested in
   the [official RabbitMQ installation guide][2]:

   ~~~ shell
   sudo wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.0/rabbitmq-server_3.6.0-1_all.deb
   ~~~

2. Install the package using `dpkg`

   ~~~ shell
   sudo dpkg -i rabbitmq-server_3.6.0-1_all.deb
   ~~~

### Install RabbitMQ using APT

The RabbitMQ website provides [instructions for installing from the official
RabbitMQ APT repository][2].

_WARNING: this installation method is not recommended for Sensu Enterprise
users, as the repository is labeled as a "testing" repo, because (according to
the RabbitMQ website) "[they] release somewhat frequently", and there shouldn't
be a reason to upgrade RabbitMQ versions frequently._

## Managing the RabbitMQ service/process

1. To enable the RabbitMQ service, you'll need to install its init scripts using
   the `update-rc.d` utility:

   ~~~ shell
   sudo update-rc.d rabbitmq-server defaults
   ~~~

2. Start and stop the RabbitMQ service using the installed init scripts:

   ~~~ shell
   sudo /etc/init.d/rabbitmq-server start
   sudo /etc/init.d/rabbitmq-server stop
   ~~~

   Alternatively, it is also possible to use the `service` command to start and
   stop the RabbitMQ service:

   ~~~ shell
   sudo service rabbitmq-server start
   sudo service rabbitmq-server stop
   ~~~

## Configure RabbitMQ access controls

Access to RabbitMQ is restricted by [access controls][5] (e.g. username and
password). For Sensu services to connect to RabbitMQ a RabbitMQ virtual host
(`vhost`) and user credentials will need to be created.

### Create a dedicated RabbitMQ `vhost` for Sensu

~~~ shell
sudo rabbitmqctl add_vhost /sensu
~~~

### Create a RabbitMQ user for Sensu

~~~ shell
sudo rabbitmqctl add_user sensu secret
sudo rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"
~~~

## Configure system limits on Linux

By default, most Linux operating systems will limit the maximum number of file
handles a single process is allowed to have open to `1024`. RabbitMQ recommends
adjusting this number to `65536` for production systems, and at least `4096` for
development environments.

> RabbitMQ installations running production workloads may need system limits and
  kernel parameters tuning in order to handle a decent number of concurrent
  connections and queues. The main setting that needs adjustment is the max
  number of open files, also known as `ulimit -n`. The default value on many
  operating systems is too low for a messaging broker (eg. 1024 on several Linux
  distributions). We recommend allowing for at least 65536 file descriptors for
  user `rabbitmq` in production environments. 4096 should be sufficient for most
  development workloads.
>
> There are two limits in play: the maximum number of open files the OS kernel
  allows (`fs.file-max`) and the per-user limit (`ulimit -n`). The former must be
  higher than the latter.

  _Source: [rabbitmq.com][2]_

To adjust this limit, please edit the configuration file found at
`/etc/default/rabbitmq-server` by uncommenting the last line in the file, and
adjusting the ulimit value to the recommendation corresponding to the
environment where RabbitMQ is running.

~~~ shell
# This file is sourced by /etc/init.d/rabbitmq-server. Its primary
# reason for existing is to allow adjustment of system limits for the
# rabbitmq-server process.
#
# Maximum number of open file handles. This will need to be increased
# to handle many simultaneous connections. Refer to the system
# documentation for ulimit (in man bash) for more information.
#
ulimit -n 65536
~~~

### Verifying the Limit

To verify that the RabbitMQ open file handle limit has been increase, please
run:

~~~ shell
rabbitmqctl status
~~~

## Configure Sensu

The following Sensu configuration files are provided as examples. Please review
the [RabbitMQ reference documentation][6] for additional information on
configuring Sensu to communicate with RabbitMQ, and the [reference documentation
on Sensu configuration][7] for more information on how Sensu loads
configuration.

### Example Standalone Configuration

1. Copy the following contents to a configuration file located at
   `/etc/sensu/conf.d/rabbitmq.json`:

   ~~~ json
   {
     "rabbitmq": {
       "host": "127.0.0.1",
       "port": 5672,
       "vhost": "/sensu",
       "user": "sensu",
       "password": "secret"
     }
   }
   ~~~

### Example Distributed Configuration

1. Obtain the IP address of the system where RabbitMQ is installed. For the
   purpose of this example, we will assume `10.0.1.6` is our IP address.

2. Create a configuration file  with the following contents at
   `/etc/sensu/conf.d/rabbitmq.json` on the Sensu server and API system(s), and
   all systems running the Sensu client:

   ~~~ json
   {
     "rabbitmq": {
       "host": "10.0.1.6",
       "port": 5672,
       "vhost": "/sensu",
       "user": "sensu",
       "password": "secret"
     }
   }
   ~~~



[1]:  https://www.erlang.org/
[2]:  http://www.rabbitmq.com/install-debian.html
[3]:  https://sensuapp.org/support
[4]:  https://www.rabbitmq.com/which-erlang.html
[5]:  https://www.rabbitmq.com/access-control.html
[6]:  ../reference/rabbitmq.html
[7]:  ../reference/configuration.html
