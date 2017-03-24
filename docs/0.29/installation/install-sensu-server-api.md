---
title: "Sensu Server and API"
description: "The complete Sensu installation guide."
version: 0.29
weight: 4
next:
  url: ../platforms/sensu-on-ubuntu-debian.html#sensu-core
  text: "Install Sensu on Ubuntu/Debian"
---

# Install the Sensu Server and API

Once you have installed [Sensu's prerequisites][1] (RabbitMQ and/or Redis), you
are ready to install a Sensu Server and API. The Sensu Server and API are
available in two flavors:

- [Sensu Core](#sensu-core)
- [Sensu Enterprise](#sensu-enterprise)

_NOTE: only one flavor of the Sensu server & API should be used at any given
time. Sensu Enterprise users should skip Sensu Core server & API installation
and jump directly to [installing Sensu Enterprise][2]._

## Sensu Core (OSS) {#sensu-core}

Sensu Core is installed via native system installer package formats (e.g. .deb,
.rpm, .msi, .pkg, etc), which are available for download from the [Sensu
Downloads][3] page, and from package manager repositories for APT (for
Ubuntu/Debian systems), and YUM (for RHEL/CentOS). The Sensu Core packages
installs several processes, including `sensu-server`, `sensu-api`, and
`sensu-client`.

- [Install the Sensu Core server & API on Ubuntu/Debian](../platforms/sensu-on-ubuntu-debian.html#sensu-core)
- [Install the Sensu Core server & API on RHEL/CentOS](../platforms/sensu-on-rhel-centos.html#sensu-core)

_NOTE: although Sensu Core packages are available for a variety of platforms
&ndash; thus making it technically possible to run the `sensu-server` and
`sensu-api` processes on non-Linux operating systems &ndash; we strongly
recommended running the Sensu Server and API on a Linux-based platform. Sensu
Core installer packages for non-Linux platforms are provided for the purpose of
making the `sensu-client` available, and are not tested as extensively for
running the `sensu-server` and `sensu-api` processes._

## Sensu Enterprise

Sensu Enterprise is installed via native system installer packages for
Linux-based operating systems, only (i.e. .deb and .rpm). The Sensu Enterprise
installer packages are made available via the Sensu Enterprise software
repositories, which requires access credentials to access. The Sensu Enterprise
package installs a single executable, `sensu-enterprise`, which provides the
functionality of Sensu server and API in a single process.

- [Install Sensu Enterprise on Ubuntu/Debian](../platforms/sensu-on-ubuntu-debian.html#sensu-enterprise)
- [Install Sensu Enterprise on RHEL/CentOS](../platforms/sensu-on-rhel-centos.html#sensu-enterprise)

[1]:  installation-prerequisites.html
[2]:  #sensu-enterprise
[3]:  https://sensuapp.org/download
