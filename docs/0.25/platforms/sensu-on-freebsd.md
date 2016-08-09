---
title: "FreeBSD"
description: "User documentation for installing and operating Sensu on FreeBSD
  systems."
version: 0.25
weight: 5
info: "<strong>NOTE:</strong> this page contains reference documentation for
  installing and operating Sensu on FreeBSD systems. For instructions on
  installing or operating Sensu on other platforms, please visit the <a
  class='alert-link' href=../overview/platforms.html>supported platforms</a>
  page."
---

# Sensu on FreeBSD

## Reference documentation

- [Installing Sensu Core](#sensu-core)
  - [Download and install Sensu using the Sensu .txz file](#download-and-install-sensu-core)
- [Configure Sensu](#configure-sensu)
  - [Create the Sensu configuration directory](#create-the-sensu-configuration-directory)
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

### Download and install Sensu using the Sensu Universal .txz file {#download-and-install-sensu-core}

1. Download Sensu from the [Sensu Downloads][1] page, or by using this link:

   [https://sensu.global.ssl.fastly.net/freebsd/10.0/amd64/sensu-0.25.3_1.txz][3]

   _NOTE: FreeBSD packages are available for FreeBSD 10.0, 10.1, and 10.2.
   Please visit the [Sensu Downloads][1] page for more information._

2. Install the `sensu-0.25.3_1.txz` package using the `pkg` utility:

   ~~~ shell
   sudo pkg add ./sensu-0.25.3_1.txz
   ~~~

3. Configure the Sensu client. **No "default" configuration is provided with
   Sensu**, so the Sensu client will not run without the corresponding
   configuration. Please refer to the ["Configure Sensu" section][9] (below),
   for more information on configuring Sensu. **At minimum, the Sensu client
   will need a working [transport definition][10] and [client definition][11]**.

## Configure Sensu

By default, all of the Sensu services on FreeBSD systems will load configuration
from the following locations:

- `/usr/local/etc/sensu/config.json`
- `/usr/local/etc/sensu/conf.d/`

_NOTE: additional or alternative configuration file and directory locations may
be used by modifying Sensu's service configuration and/or by starting the Sensu
services with the corresponding CLI arguments. For more information, please
consult the [Sensu Configuration][5] reference documentation._

### Create the Sensu configuration directory

In some cases, the default Sensu configuration directory (i.e.
`/etc/sensu/conf.d/`) is not created by the Sensu installer, in which case it is
necessary to create this directory manually.

~~~ shell
mkdir /usr/local/etc/sensu/conf.d
~~~

### Example client configuration

1. Copy the following contents to a configuration file located at
   `/usr/local/etc/sensu/conf.d/client.json`:

   ~~~ json
   {
     "client": {
       "name": "freebsd",
       "address": "127.0.0.1",
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
connect to the configured [Sensu Transport][6].

1. Copy the following contents to a configuration file located at
   `/usr/local/etc/sensu/conf.d/transport.json`:

   ~~~ json
   {
     "transport": {
       "name": "rabbitmq",
       "reconnect_on_error": true
     }
   }
   ~~~

   _NOTE: if you are using Redis as your transport, please use `"name": "redis"`
   for your transport configuration. For more information, please visit the
   [transport definition specification][10]._

2. Please refer to the configuration instructions for the corresponding
   transport for configuration file examples (see [Redis][7], or [RabbitMQ][8]
   reference documentation).

## Operating Sensu

Coming soon...

[1]:  https://sensuapp.org/download
[2]:  https://sensu.global.ssl.fastly.net/freebsd/10.0/amd64/
[3]:  https://sensu.global.ssl.fastly.net/freebsd/10.0/amd64/sensu-0.25.3_1.txz
[4]:  https://sensuapp.org/mit-license
[5]:  ../reference/configuration.html
[6]:  ../reference/transport.html
[7]:  ../reference/redis.html#sensu-redis-configuration
[8]:  ../reference/rabbitmq.html#sensu-rabbitmq-configuration
[9]:  #configure-sensu
[10]: #example-transport-configuration
[11]: #example-client-configuration
