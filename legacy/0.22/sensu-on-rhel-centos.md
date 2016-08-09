---
version: 0.22
category: "Installation Guide"
title: "Install Sensu on RHEL/CentOS"
---

# Sensu on RHEL/CentOS

- [Installing Sensu Core](#sensu-core)
  - [Install Sensu using YUM](#install-sensu-core-repository)
- [Installing Sensu Enterprise](#sensu-enterprise)
  - [Install the Sensu Enterprise repository](#install-sensu-enterprise-repository)
  - [Install Sensu Enterprise (server & API)](#install-sensu-enterprise)
- [Configure Sensu](#configure-sensu)
  - [Example client configuration](#example-client-configuration)
  - [Example transport configuration](#example-transport-configuration)
  - [Example data store configuration](#example-data-store-configuration)
  - [Example API configurations](#example-api-configurations)
    - [Standalone configuration](#api-standalone-configuration)
    - [Distributed configuration](#api-distributed-configuration)
  - [Example Sensu Enterprise Dashboard configurations](#example-sensu-enterprise-dashboard-configurations)
    - [Standalone configuration](#dashboard-standalone-configuration)
    - [Distributed configuration](#dashboard-distributed-configuration)
  - [Enable the Sensu services to start on boot](#enable-the-sensu-services-to-start-on-boot)
  - [Disable the Sensu services on boot](#disable-the-sensu-services-on-boot)
- [Operating Sensu](#operating-sensu)
  - [Managing the Sensu services/processes](#service-management)

## Install Sensu Core {#sensu-core}

Sensu Core is installed on RHEL and CentOS systems via a native system installer
package (i.e. a .rpm file), which is available for download from the [Sensu
Downloads][1] page, and from YUM package management repositories. The Sensu Core
package installs several processes including `sensu-server`, `sensu-api`, and
`sensu-client`.

### Install Sensu using APT (recommended) {#install-sensu-core-repository}

1. Create the YUM repository configuration file for the Sensu Core repository at    
   `/etc/yum.repos.d/sensu.repo`:

   ~~~ shell
   echo '[sensu]
   name=sensu
   baseurl=http://repositories.sensuapp.org/yum/$basearch/
   gpgcheck=0
   enabled=1' | sudo tee /etc/yum.repos.d/sensu.repo
   ~~~

2. Install Sensu

   ~~~ shell
   sudo yum install sensu
   ~~~

   _NOTE: as mentioned above, the `sensu` package installs all of the Sensu Core
   processes, including `sensu-client`, `sensu-server`, and `sensu-api`._

## Install Sensu Enterprise {#sensu-enterprise}

[Sensu Enterprise][2] is installed on RHEL and CentOS systems via a native
system installer package (i.e. a .rpm file). The Sensu Enterprise installer
package is made available via the Sensu Enterprise YUM repository, which
requires access credentials to access. The Sensu Enterprise packages install two
processes: `sensu-enterprise` (which provides the Sensu server and API from a
single process), and `sensu-enterprise-dashboard` (which provides the dashboard
API and web application).

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

 3. Create a YUM repository configuration file for the Sensu Enterprise
    repository at `/etc/yum.repos.d/sensu-enterprise.repo`:

    ~~~ shell
    echo "[sensu-enterprise]
    name=sensu-enterprise
    baseurl=http://$SE_USER:$SE_PASS@enterprise.sensuapp.com/yum/noarch/
    gpgcheck=0
    enabled=1" | sudo tee /etc/yum.repos.d/sensu-enterprise.repo
    ~~~

4. Create a YUM repository configuration file for the Sensu Enterprise Dashboard
   repository at `/etc/yum.repos.d/sensu-enterprise-dashboard.repo`:

   ~~~ shell
   echo "[sensu-enterprise-dashboard]
   name=sensu-enterprise-dashboard
   baseurl=http://$SE_USER:$SE_PASS@enterprise.sensuapp.com/yum/\$basearch/
   gpgcheck=0
   enabled=1" | sudo tee /etc/yum.repos.d/sensu-enterprise-dashboard.repo
   ~~~

5. Install Sensu Enterprise

   ~~~ shell
   sudo yum install sensu-enterprise sensu-enterprise-dashboard
   ~~~

## Configure Sensu

By default, all of the Sensu services on Ubuntu and Debian systems will load
configuration from the following locations:

- `/etc/sensu/config.json`
- `/etc/sensu/conf.d/`

_NOTE: Additional or alternative configuration file and directory locations may
be used by modifying Sensu's init scripts and/or by starting the Sensu services
with the corresponding CLI arguments. For more information, please consult the
[Sensu Configuration][3] reference documentation._

The following Sensu configuration files are provided as examples. Please review
the [Sensu configuration reference documentation][3] for additional information
on how Sensu is configured.

### Example client configuration

1. Copy the following contents to a configuration file located at
   `/etc/sensu/conf.d/client.json`:

   ~~~ json
   {
     "client": {
       "name": "rhel",
       "address": "localhost",
       "environment": "development",
       "subscriptions": [
         "dev",
         "rhel"
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
connect to the configured [Sensu Transport][4]. Please refer to the
configuration instructions for the corresponding transport for configuration
file examples (see [Install Redis][5], or [Install RabbitMQ][6]).

### Example data store configuration

The Sensu Core server and API processes, and the Sensu Enterprise process all
require configuration to tell them how to connect to Redis (the Sensu data
store). Please refer to the [Redis installation instructions][5] for
configuration file examples.

### Example API configurations

#### Standalone configuration {#api-standalone-configuration}

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

#### Distributed configuration {#api-distributed-configuration}

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

### Example Sensu Enterprise Dashboard configurations

#### Standalone configuration {#dashboard-standalone-configuration}

1. Copy the following contents to a configuration file located at
   `/etc/sensu/dashboard.json`:

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

#### Distributed configuration {#dashboard-distributed-configuration}

1. Obtain the IP address of the system where Sensu Enterprise is installed. For
   the purpose of this guide, we will use `10.0.1.7` as our example IP address.

2. Copy the following contents to a configuration file located at
   `/etc/sensu/dashboard.json`:

   ~~~ json
   {
     "sensu": [
       {
         "name": "Datacenter 1",
         "host": "10.0.1.7",
         "port": 4567
       }
     ],
     "dashboard": {
       "host": "0.0.0.0",
       "port": 3000
     }
   }
   ~~~

   _NOTE: Multiple Sensu Enterprise Dashboard instances can be installed. When
   load balancing across multiple Dashboard instances, your load balancer should
   support "sticky sessions"._

3. The Sensu Enterprise Dashboard process requires configuration to tell it how
   to connect to Redis (the Sensu data store). Please refer to the [Redis
   installation instructions][5] for configuration file examples.

### Enable the Sensu services to start on boot

By default, the Sensu services are not configured to start automatically on
system boot (we recommend managing the Sensu services with a process supervisor
such as [runit][7]). To enable Sensu services on system boot, use the
[`chkconfig` utility][8].

- Enable the Sensu client on system boot

  ~~~ shell
  sudo chkconfig sensu-client on
  ~~~

- Enable the Sensu server and API to start on system boot
  - For Sensu Core users (i.e. `sensu-server` and `sensu-api`)

    ~~~ shell
    sudo chkconfig sensu-server on
    sudo chkconfig sensu-api on
    ~~~

  - For Sensu Enterprise users

    ~~~ shell
    sudo chkconfig sensu-enterprise on
    ~~~

    _WARNING: the `sensu-enterprise` process is intended to be a drop-in
    replacement for the Sensu Core `sensu-server` and `sensu-api` processes.
    Please [ensure that the Sensu Core processes are not configured to start on
    system][8] boot before enabling Sensu Enterprise to start on system boot._

- Enable Sensu Enterprise Dashboard on system boot

  ~~~ shell
  sudo chkconfig sensu-enterprise-dashboard defaults
  ~~~

  _WARNING: the `sensu-enterprise-dashboard` process is intended to be a drop-in
  replacement for the Uchiwa dashboard. Please ensure that the Uchiwa processes
  are not configured to start on system boot before enabling the Sensu
  Enterprise Dashboard to start on system boot._


### Disable the Sensu services on boot

If you have enabled Sensu services on boot and now need to disable them, this
can also be accomplished using the [`chkconfig` utility][9].

- Disable the Sensu client on system boot

  ~~~ shell
  sudo chkconfig sensu-client off
  ~~~

- Disable the Sensu Core server on system boot

  ~~~ shell
  sudo chkconfig sensu-server off
  ~~~

- Disable the Sensu Core API on system boot

  ~~~ shell
  sudo chkconfig sensu-api off
  ~~~

- Disable Sensu Enterprise on system boot

  ~~~ shell
  sudo chkconfig sensu-enterprise off
  ~~~

- Disable Sensu Enterprise Dashboard on system boot

  ~~~ shell
  sudo chkconfig sensu-enterprise-dashboard remove
  ~~~

## Operating Sensu {#operating-sensu}

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

- Start or stop the Sensu Enterprise Dashboard

  ~~~ shell
  sudo /etc/init.d/sensu-enterprise-dashboard start
  sudo /etc/init.d/sensu-enterprise-dashboard stop
  ~~~

  Verify the Sensu Enterprise Dashboard is running by visiting view the
  dashboard at http://localhost:3000 (replace `localhost` with the hostname or
  IP address where the Sensu Enterprise Dashboard is running).


[1]:  https://sensuapp.org/download
[2]:  https://sensuapp.org/sensu-enterprise
[3]:  configuration
[4]:  transport
[5]:  install-redis
[6]:  install-rabbitmq
[7]:  http://smarden.org/runit/
[8]:  #disable-the-sensu-services-on-boot
[9]:  https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/s2-services-chkconfig.html
