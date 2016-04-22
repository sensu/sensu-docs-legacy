---
version: 0.23
category: "Architecture"
title: "Supported Platforms"
next:
  url: "installation-guide"
  text: "Get started!"
---

# Supported Platforms

## Sensu Core

All versions of Sensu (including Sensu Enterprise) are based on the same core
components and functionality, which are provided by the [Sensu open-source
software project][1] and collectively referred to as Sensu Core. Sensu Core
provides multiple processes, including the [Sensu server][2] (`sensu-server`),
[Sensu API][3] (`sensu-api`), and [Sensu client][4] (`sensu-client`).

Installer packages are available for most modern operating systems via native
installer packages (e.g. .deb, .rpm, .msi, .pkg, etc) which are available for
[download from the Sensu website][5], and from package manager repositories for
APT (for Ubuntu/Debian systems), and YUM (for RHEL/CentOS).

_NOTE: although Sensu Core packages are available for a variety of platforms
&ndash; thus making it technically possible to run the `sensu-server` and
`sensu-api` processes on non-Linux operating systems &ndash; **we strongly
recommended running the Sensu Server and API on a Linux-based platform**. Sensu
Core installer packages for non-Linux platforms are provided for the purpose of
making the `sensu-client` available, and are not tested as extensively for
running the `sensu-server` and `sensu-api` processes._

### Sensu Server & API

- [Ubuntu/Debian](sensu-on-ubuntu-debian#sensu-core) (recommended)
- [RHEL/CentOS](sensu-on-rhel-centos#sensu-core)

### Sensu Client

- [Ubuntu/Debian](sensu-on-ubuntu-debian#sensu-core)
- [RHEL/CentOS](sensu-on-rhel-centos#sensu-core)
- [Microsoft Windows](sensu-on-microsoft-windows#sensu-core)
- [Mac OS X](sensu-on-mac-os-x#sensu-core)
- [FreeBSD](sensu-on-freebsd#sensu-core)
- [IBM AIX](sensu-on-ibm-aix#sensu-core)
- [Oracle Solaris](sensu-on-oracle-solaris#sensu-core)
- [Raspberry Pi](sensu-on-raspberry-pi#sensu-core) (coming soon)

## Sensu Enterprise

[Sensu Enterprise][6] is designed to be a drop-in replacement for the Sensu Core
server and API, _only_ (i.e. Sensu Enterprise uses the same client as Sensu
Core). Sensu Enterprise provides a single process called `sensu-enterprise`
which provides [added-value][7] replacements for the Sensu Core server
(`sensu-server`) and API (`sensu-api`).

### Sensu Enterprise Server & API

- [Ubuntu/Debian](sensu-on-ubuntu-debian#sensu-enterprise) (recommended)
- [RHEL/CentOS](sensu-on-rhel-centos#sensu-enterprise)

### Sensu Enterprise Client

As mentioned above, **Sensu Enterprise uses the same `sensu-client` process as
Sensu Core**. By sharing the same open-source monitoring agent, upgrading to
Sensu Enterprise from Sensu Core is simplified, as there's no need to upgrade
agents &mdash; simply replace the server and API components. Consequently,
**Sensu Enterprise does not need to be installed on every system being monitored
by Sensu**.

[1]:  https://github.com/sensu
[2]:  server
[3]:  api
[4]:  client
[5]:  https://sensuapp.org/download
[6]:  https://sensuapp.org/sensu-enterprise
[7]:  https://sensuapp.org/sensu-enterprise#advantage
