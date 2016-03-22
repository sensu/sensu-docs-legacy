---
version: 0.22
category: "Installation Guide"
title: "Install the Sensu Server and API"
next:
  url: "install-sensu-client"
  text: "Install Sensu Client"
---

# Install the Sensu Server and API

Once you have installed [Sensu's prerequisites][prereqs] (RabbitMQ and/or
Redis), you are ready to install a Sensu Server and API. The Sensu Server and
API are available in two flavors:

- [Sensu Core](#sensu-core)
- [Sensu Enterprise](#sensu-enterprise)

_NOTE: only one flavor of the Sensu server & API should be used at any given
time. Sensu Enterprise users should skip Sensu Core server & API installation
and jump directly to [installing Sensu Enterprise](#sensu-enterprise)._

## Sensu Core (OSS) {#sensu-core}

Sensu Core is installed via native system installer package formats (e.g. .deb,
.rpm, .msi, .pkg, etc), which are available for download from the [Sensu
Downloads][downloads] page, and from package manager repositories for APT (for
Ubuntu/Debian systems), and YUM (for RHEL/CentOS). The Sensu Core packages
installs several processes, including `sensu-server`, `sensu-api`, and
`sensu-client`.

- [Install the Sensu server & API on Ubuntu/Debian](sensu-on-ubuntu-debian)
- [Install the Sensu server & API on RHEL/CentOS](sensu-on-rhel-centos)

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
packages install two processes: `sensu-enterprise` (which provides the Sensu
server and API from a single process).

- [Install Sensu Enterprise on Ubuntu/Debian](sensu-on-ubuntu-debian#sensu-enterprise)
- [Install Sensu Enterprise on RHEL/CentOS](sensu-on-rhel-centos#sensu-enterprise)

[prereqs]:        installation-prerequisites
[downloads]:      https://sensuapp.org/download
