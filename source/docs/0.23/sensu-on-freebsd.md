---
version: 0.23
category: "Installation Guide"
title: "Sensu on FreeBSD"
---

# Sensu on FreeBSD

- [Installing Sensu Core](#sensu-core)
  - [Download and install Sensu using the Sensu .txz file](#download-and-install-sensu-core)
- [Configure Sensu](#configure-sensu)
  - [Example client configuration](#example-client-configuration)
  - [Example transport configuration](#example-transport-configuration)
- [Operating Sensu](#operating-sensu)
  - [Managing the Sensu client process](#service-management)

## Install Sensu Core {#sensu-core}

Sensu Core is installed on FreeBSD systems via a native system installer package
(i.e. a .txz file), which is available for download from the [Sensu
Downloads][1] page, and from [this repository (64-bit FreeBSD 10+ only)][2].

_WARNING: FreeBSD packages are currently as a "beta" release. Support for
running Sensu on FreeBSD will be provided on a best-effort basis until further
notice._

### Download and install Sensu using the Sensu Universal .pkg file {#download-and-install-sensu-core}

1. Download Sensu from the [Sensu Downloads][1] page, or by using this link:

   [https://core.sensuapp.com/freebsd-unstable/10.0/amd64/sensu-0.23.0_1.txz][3]

2. Double-click the `sensu-0.23.0_1.txz` installer package to launch the
   installer, accept the Sensu Core [MIT License][4] and install Sensu
   using the default settings (e.g. install location, etc).

   _WARNING: changing the default installation path from `/opt/sensu` is
   strongly discouraged._

## Configure Sensu

By default, all of the Sensu services on FreeBSD systems will load configuration
from the following locations:

- `/etc/sensu/config.json`
- `/etc/sensu/conf.d/`

_NOTE: additional or alternative configuration file and directory locations may
be used by modifying Sensu's service configuration XML and/or by starting the
Sensu services with the corresponding CLI arguments. For more information,
please consult the [Sensu Configuration](configuration) reference
documentation._

The following Sensu configuration files are provided as examples. Please review
the [Sensu configuration reference documentation][5] for additional information
on how Sensu is configured.

### Example client configuration

1. Copy the following contents to a configuration file located at
   `/etc/sensu/conf.d/client.json`:

   ~~~ json
   {
     "client": {
       "name": "freebsd",
       "address": "localhost",
       "environment": "development",
       "subscriptions": [
         "dev",
         "freebsd"
       ],
       "socket": {
         "bind": "127.0.0.1",
         "port": 3030
       }
     }
   }
   ~~~

### Example Transport Configuration

At minimum, the Sensu client process requires configuration to tell it how to
connect to the configured [Sensu Transport][6]. Please refer to the
configuration instructions for the corresponding transport for configuration
file examples (see [Install Redis][7], or [Install RabbitMQ][8]).

## Operating Sensu

Coming soon...

[1]:  https://sensuapp.org/download
[2]:  https://core.sensuapp.com/freebsd-unstable/10.0/amd64/
[3]:  https://core.sensuapp.com/freebsd-unstable/10.0/amd64/sensu-0.23.0_1.txz
[4]:  https://sensuapp.org/mit-license
[5]:  configuration
[6]:  transport
[7]:  install-redis
[8]:  install-rabbitmq
