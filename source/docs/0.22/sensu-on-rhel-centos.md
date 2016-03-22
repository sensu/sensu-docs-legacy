---
version: 0.22
category: "Installation Guide"
title: "Install Sensu on RHEL/CentOS"
---

# Sensu on RHEL/CentOS

- [Installing Sensu Core](#sensu-core)
  - [Install Sensu using YUM](#install-sensu-core-repository)
  - [Download and install Sensu using `rpm`](#download-and-install-sensu-core)
- [Installing Sensu Enterprise](#sensu-enterprise)
  - [Install the Sensu Enterprise repository](#install-sensu-enterprise-repository)
  - [Install Sensu Enterprise (server & API)](#install-sensu-enterprise)
- [Configure Sensu](#configure-sensu)
  - [Example standalone configuration](#example-standalone-configuration)
  - [Example distributed configuration](#example-distributed-configuration)
  - [Enable the Sensu services to start on boot](#enable-the-sensu-services-to-start-on-boot)
  - [Disable the Sensu services on boot](#disable-the-sensu-services-on-boot)
- [Operating Sensu](#operating-sensu)
  - [Managing the Sensu services/processes](#service-management)

## Install Sensu Core {#sensu-core}

Sensu Core is installed on RHEL and CentOS systems via a native system installer
package (i.e. a .rpm file), which is available for download from the [Sensu
Downloads][download] page, and from YUM package management repositories.
The Sensu Core package installs several processes including `sensu-server`,
`sensu-api`, and `sensu-client`.

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

### Download and install Sensu using `dpkg` {#download-and-install-sensu-core}

1. Download and install Sensu using `rpm` (or visit the Sensu website and
   download Sensu from the [Sensu Downloads][download] page)

   For `x86_64` architectures:

   ~~~ shell
   rpm -Uvh https://core.sensuapp.com/yum/x86_64/sensu-0.22.1-1.x86_64.rpm
   ~~~

   For `i386` architectures:

   ~~~ shell
   rpm -Uvh https://core.sensuapp.com/yum/i386/sensu-0.22.1-1.i386.rpm
   ~~~

## Install Sensu Enterprise {#sensu-enterprise}

[Sensu Enterprise][sensu-enterprise] is installed on RHEL and CentOS systems
via a native system installer package (i.e. a .rpm file). The Sensu Enterprise
installer package is made available via the Sensu Enterprise YUM repository,
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
[Sensu Configuration](configuration) reference documentation._

The following Sensu configuration files are provided as examples. Please review
the [Sensu configuration reference documentation](configuration) for additional
information on how Sensu is configured.

### Example Standalone Configuration

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

### Example Distributed Configuration

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
boot, use the [`chkconfig` utility][chkconfig].

- Enable the Sensu client on system boot

  ~~~ shell
  sudo chkconfig sensu-client on
  ~~~

- Enable the Sensu Core server on system boot

  ~~~ shell
  sudo chkconfig sensu-server on
  ~~~

- Enable the Sensu Core API on system boot

  ~~~ shell
  sudo chkconfig sensu-api on
  ~~~

- Enable Sensu Enterprise on system boot

  ~~~ shell
  sudo chkconfig sensu-enterprise on
  ~~~

  _WARNING: the `sensu-enterprise` process is intended to be a drop-in
  replacement for the Sensu Core `sensu-server` and `sensu-api` processes.
  Please [ensure that the Sensu Core processes are not configured to start on
  system](#disable-the-sensu-services-on-boot) boot before enabling Sensu
  Enterprise to start on system boot._

### Disable the Sensu services on boot

If you have enabled Sensu services on boot and now need to disable them, this
can also be accomplished using the [`chkconfig` utility][chkconfig].

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



[download]:             https://sensuapp.org/download
[sensu-enterprise]:     https://sensuapp.org/sensu-enterprise
[chkconfig]:            https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/s2-services-chkconfig.html
