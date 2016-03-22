---
version: 0.22
category: "Installation Guide"
title: "Install the Sensu Client"
---

# Install the Sensu Client

Having successfully installed and configured a Sensu server and API (Sensu Core
or Sensu Enterprise), let's now install and/or configure a Sensu client. The
Sensu client is run on every system you need to monitor, including those running
the Sensu server and API, and Sensu's dependencies (i.e. RabbitMQ and/or
Redis). **Both Sensu Core and Sensu Enterprise use the same Sensu client
process** (i.e. `sensu-client`), so upgrading from Sensu Core to Sensu
Enterprise does not require you to install a difference Sensu client.

## Included in Sensu Core

The Sensu client process (`sensu-client`) is part of the open source Sensu
project (i.e. Sensu Core) and it is included in the Sensu Core installer
packages along with the Sensu Core server and API processes (i.e. `sensu-server`
and `sensu-api`). This means that if you are following the instructions in this
guide for a [standalone][standalone] installation, your Sensu client is already
installed!

## Disabled by default

The Sensu client process (`sensu-client`) is disabled by default on all
platforms. Please refer to the corresponding configuration and operation
documentation corresponding to the platform where you have installed your Sensu
client(s) for instructions on starting & stopping the Sensu client process,
and/or enabling the Sensu client process to start automatically on system boot.

## Platforms

To continue with this guide, please refer to the **Install Sensu Core**,
**Configure Sensu**, and **Operating Sensu** instructions corresponding to the
platform(s) where you will run your Sensu client(s).

- [Ubuntu/Debian](sensu-on-ubuntu-debian#install-sensu-core)
- [RHEL/CentOS](sensu-on-rhel-centos#install-sensu-core)
- [Microsoft Windows](sensu-on-microsoft-windows#install-sensu-core)
- [Mac OS X](sensu-on-mac-os-x#install-sensu-core) (beta)
- [FreeBSD](sensu-on-freebsd#install-sensu-core) (beta)
- [IBM AIX](sensu-on-ibm-aix#install-sensu-core) (coming soon)
- [Oracle Solaris](sensu-on-oracle-solaris#install-sensu-core) (coming soon)
- [Raspberry Pi](sensu-on-raspberry-pi#install-sensu-core) (beta)


[standalone]:       installation-strategies#standalone
