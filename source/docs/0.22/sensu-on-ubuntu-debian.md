---
version: 0.22
category: "Installation Guide"
title: "Install Sensu on Ubuntu/Debian"
---

# Sensu on Ubuntu/Debian

- [Installing Sensu Core](#sensu-core)
  - [Install Sensu using APT](#install-sensu-core-repository)
  - [Download and install Sensu using `dpkg`](#download-and-install-sensu-core)
- [Installing Sensu Enterprise](#sensu-enterprise)
  - [Install the Sensu Enterprise repository](#install-sensu-enterprise-repository)
  - [Install Sensu Enterprise (server & API)](#install-sensu-enterprise)
- [Configure Sensu](#configure-sensu)
  - [Example client configuration](#example-client-configuration)
  - [Example transport configuration](#example-transport-configuration)
  - [Example data store configuration](#example-data-store-configuration)
  - [Example standalone API configuration](#example-standalone-configuration)
  - [Example distributed API configuration](#example-distributed-configuration)
  - [Enable the Sensu services to start on boot](#enable-the-sensu-services-to-start-on-boot)
  - [Disable the Sensu services on boot](#disable-the-sensu-services-on-boot)
- [Operating Sensu](#operating-sensu)
  - [Managing the Sensu services/processes](#service-management)

## Install Sensu Core {#sensu-core}

Sensu Core is installed on Ubuntu and Debian systems via a native system
installer package (i.e. a .deb file), which is available for download from the
[Sensu Downloads][download] page, and from APT package management repositories.
The Sensu Core package installs several processes including `sensu-server`,
`sensu-api`, and `sensu-client`.

### Install Sensu using APT (recommended) {#install-sensu-core-repository}

1. Install the GPG public key

   ~~~ shell
   wget -q http://repositories.sensuapp.org/apt/pubkey.gpg -O- | sudo apt-key add -
   ~~~

2. Create an APT configuration file at `/etc/apt/sources.list.d/sensu.list`

   ~~~ shell
   echo "deb     http://repositories.sensuapp.org/apt sensu main" | sudo tee /etc/apt/sources.list.d/sensu.list
   ~~~

3. Update APT

   ~~~ shell
   sudo apt-get update
   ~~~

4. Install Sensu

   ~~~ shell
   sudo apt-get install sensu
   ~~~

   _NOTE: as mentioned above, the `sensu` package installs all of the Sensu Core
   processes, including `sensu-client`, `sensu-server`, and `sensu-api`._

### Download and install Sensu using `dpkg` {#download-and-install-sensu-core}

1. Download Sensu using `wget` (or visit the Sensu website and download Sensu
   from the [Sensu Downloads][download] page)

   For `amd64` architectures:

   ~~~ shell
   wget https://core.sensuapp.com/apt/pool/sensu/main/s/sensu/sensu_0.22.1-1_amd64.deb
   ~~~

   For `i386` architectures:

   ~~~ shell
   wget https://core.sensuapp.com/apt/pool/sensu/main/s/sensu/sensu_0.22.1-1_i386.deb
   ~~~

2. Install Sensu using the `dpkg` utility:

   For `amd64` architectures:

   ~~~ shell
   sudo dpkg -i sensu_0.22.1-1_amd64.deb
   ~~~

   For `i386` architectures:

   ~~~ shell
   sudo dpkg -i sensu_0.22.1-1_i386.deb
   ~~~

## Install Sensu Enterprise {#sensu-enterprise}

[Sensu Enterprise][sensu-enterprise] is installed on Ubuntu and Debian systems
via a native system installer package (i.e. a .deb file). The Sensu Enterprise
installer package is made available via the Sensu Enterprise APT repository,
which requires access credentials to access. The Sensu Enterprise packages
install two processes: `sensu-enterprise` (which provides the Sensu server and
API from a single process), and `sensu-enterprise-dashboard` (which provides
the dashboard API and web application).

### Install the Sensu Enterprise repository {#install-sensu-enterprise-repository}

1. Set access credentials as environment variables

   ~~~ shell
   SE_USER=1234567890
   SE_PASS=PASSWORD
   ~~~

   _NOTE: please replace `1234567890` and `PASSWORD` with the access credentials
   provided with your Sensu Enterprise subscription._

   Confirm that you have correctly set your access credentials as environment
   variables

   ~~~ shell
   $ echo $SE_USER:$SE_PASS
   1234567890:PASSWORD
   ~~~

2. Install the GPG public key

   ~~~ shell
   wget -q http://$SE_USER:$SE_PASS@enterprise.sensuapp.com/apt/pubkey.gpg -O- | sudo apt-key add -
   ~~~

3. Create an APT configuration file at `/etc/apt/sources.list.d/sensu-enterprise.list`

   ~~~ shell
   echo "deb     http://$SE_USER:$SE_PASS@enterprise.sensuapp.com/apt sensu-enterprise main" | sudo tee /etc/apt/sources.list.d/sensu-enterprise.list
   ~~~

4. Update APT

   ~~~ shell
   sudo apt-get update
   ~~~

5. Install Sensu Enterprise

   ~~~ shell
   sudo apt-get install sensu-enterprise sensu-enterprise-dashboard
   ~~~

## Configure Sensu

By default, all of the Sensu services on Ubuntu and Debian systems will load
configuration from the following locations:

- `/etc/sensu/config.json`
- `/etc/sensu/conf.d/`

_NOTE: Additional or alternative configuration file and directory locations may
be used by modifying Sensu's init scripts and/or by starting the Sensu services
with the corresponding CLI arguments. For more information, please consult the
[Sensu Configuration](configuration) reference documentation._

The following Sensu configuration files are provided as examples. Please review
the [Sensu configuration reference documentation](configuration) for additional
information on how Sensu is configured.

### Example client configuration

1. Copy the following contents to a configuration file located at
   `/etc/sensu/conf.d/client.json`:

   ~~~ json
   {
     "client": {
       "name": "ubuntu",
       "address": "localhost",
       "environment": "development",
       "subscriptions": [
         "dev",
         "ubuntu"
       ],
       "socket": {
         "bind": "127.0.0.1",
         "port": 3030
       }
     }
   }
   ~~~

### Example transport configuration

At minimum, all of the Sensu processes require configuration to tell them how to
connect to the configured [Sensu Transport](transport). Please refer to the
configuration instructions for the corresponding transport for configuration
file examples (see [Install Redis](install-redis), or [Install
RabbitMQ](install-rabbitmq)).

### Example data store configuration

The Sensu Core server and API processes, and the Sensu Enterprise process all
require configuration to tell them how to connect to Redis (the Sensu data
store). Please refer to the [Redis installation instructions](install-redis) for
configuration file examples.

### Example Standalone API Configuration

1. Copy the following contents to a configuration file located at
   `/etc/sensu/conf.d/api.json`:

   ~~~ json
   {
     "api": {
       "host": "localhost",
       "bind": "0.0.0.0",
       "port": 4567
     }
   }
   ~~~

### Example Distributed API Configuration

1. Obtain the IP address of the system where the Sensu API is installed. For the
   purpose of this guide, we will use `10.0.1.7` as our example IP address.

1. Create a configuration file  with the following contents at
   `/etc/sensu/conf.d/api.json` on the Sensu server and API system(s):

   ~~~ json
   {
     "api": {
       "host": "10.0.1.7",
       "bind": "10.0.1.7",
       "port": 4567
     }
   }
   ~~~

### Enable the Sensu services to start on boot

By default, the Sensu services are not configured to start automatically on
system boot (we recommend managing the Sensu services with a process supervisor
such as [runit](http://smarden.org/runit/)). To enable Sensu services on system
boot, use the `update-rc.d` utility.

- Enable the Sensu client on system boot

  ~~~ shell
  sudo update-rc.d sensu-client defaults
  ~~~

- Enable the Sensu Core server on system boot

  ~~~ shell
  sudo update-rc.d sensu-server defaults
  ~~~

- Enable the Sensu Core API on system boot

  ~~~ shell
  sudo update-rc.d sensu-api defaults
  ~~~

- Enable Sensu Enterprise on system boot

  ~~~ shell
  sudo update-rc.d sensu-enterprise defaults
  ~~~

  _WARNING: the `sensu-enterprise` process is intended to be a drop-in
  replacement for the Sensu Core `sensu-server` and `sensu-api` processes.
  Please [ensure that the Sensu Core processes are not configured to start on
  system](#disable-the-sensu-services-on-boot) boot before enabling Sensu
  Enterprise to start on system boot._

### Disable the Sensu services on boot

If you have enabled Sensu services on boot and now need to disable them, this
can also be accomplished using the [`update-rc.d` utility][update-rcd].

- Disable the Sensu client on system boot

  ~~~ shell
  sudo update-rc.d sensu-client remove
  ~~~

- Disable the Sensu Core server on system boot

  ~~~ shell
  sudo update-rc.d sensu-server remove
  ~~~

- Disable the Sensu Core API on system boot

  ~~~ shell
  sudo update-rc.d sensu-api remove
  ~~~

- Disable Sensu Enterprise on system boot

  ~~~ shell
  sudo update-rc.d sensu-enterprise remove
  ~~~

## Operating Sensu

### Managing the Sensu services/processes {#service-management}

To manually start and stop the Sensu services, use the provided init scripts:

- Start or stop the Sensu client

  ~~~ shell
  sudo /etc/init.d/sensu-client start
  sudo /etc/init.d/sensu-client stop
  ~~~

- Start or stop the Sensu Core server

  ~~~ shell
  sudo /etc/init.d/sensu-server start
  sudo /etc/init.d/sensu-server stop
  ~~~

- Start or stop the Sensu Core API

  ~~~ shell
  sudo /etc/init.d/sensu-api start
  sudo /etc/init.d/sensu-api stop
  ~~~

- Start or stop Sensu Enterprise

  ~~~ shell
  sudo /etc/init.d/sensu-enterprise start
  sudo /etc/init.d/sensu-enterprise stop
  ~~~



[download]:             https://sensuapp.org/download
[sensu-enterprise]:     https://sensuapp.org/sensu-enterprise
[update-rcd]:           http://manpages.ubuntu.com/manpages/precise/man8/update-rc.d.8.html
