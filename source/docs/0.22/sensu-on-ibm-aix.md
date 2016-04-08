---
version: 0.22
category: "Installation Guide"
title: "Sensu on IBM AIX"
---

# Sensu on IBM AIX

- [Installing Sensu Core](#sensu-core)
  - [Download and install Sensu using the Sensu .bff file](#download-and-install-sensu-core)
- [Configure Sensu](#configure-sensu)
  - [Example client configuration](#example-client-configuration)
  - [Example transport configuration](#example-transport-configuration)
- [Operating Sensu](#operating-sensu)
  - [Managing the Sensu client process](#service-management)
- [Known issues](#known-issues)


## Install Sensu Core {#sensu-core}

Sensu Core is installed on FreeBSD systems via a native system installer package
(i.e. a .bff file), which is available for download from the [Sensu
Downloads][1] page, and from [this repository (64-bit FreeBSD 10+ only)][2].

### Download and install Sensu using the Sensu .bff package {#download-and-install-sensu-core}

1. Download Sensu from the [Sensu Downloads][1] page, or by using this link:

   ~~~ shell
   wget https://core.sensuapp.com/aix-unstable/
   ~~~

2. The Sensu installer package for IBM AIX systems is provided in **backup file
   format** (.bff). In order to install the content, you will need to know the
   "Fileset Name". Display the content using the `installp` utility.

   ~~~ shell
   installp -ld sensu-0.22.2_1.powerpc.bff
   ~~~

   Once you have collected the fileset name, you can optionally proceed to
   preview installation using the `installp` utility, with the `-p` (preview)
   flag.

   ~~~ shell
   installp -apXY -d sensu-0.22.2_1.powerpc.bff sensu
   ~~~

3. Install Sensu using the `installp` utility.

   ~~~ shell
   installp -aXY -d sensu-0.22.2_1.powerpc.bff sensu
   ~~~

   _NOTE: this command uses the following `installp` utilty flags: `-a` to apply
   changes to the system, `-X` to extend the file system, and `-Y` to accept the
   [Sensu MIT License][4]._

## Configure Sensu

By default, all of the Sensu services on IBM AIX systems will load configuration
from the following locations:

- `/etc/sensu/config.json`
- `/etc/sensu/conf.d/**/*.json`

_NOTE: additional or alternative configuration file and directory locations may
be used by modifying Sensu's service configuration and/or by starting the Sensu
services with the corresponding CLI arguments. For more information, please
consult the [Sensu Configuration][5] reference documentation._

The following Sensu configuration files are provided as examples. Please review
the [Sensu configuration reference documentation][5] for additional information
on how Sensu is configured.

### Example client configuration

1. Copy the following contents to a configuration file located at
   `/etc/sensu/conf.d/client.json`:

   ~~~ json
   {
     "client": {
       "name": "aix",
       "address": "localhost",
       "environment": "development",
       "subscriptions": [
         "dev",
         "aix"
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

## Known issues

### SSL



### libffi



[1]:  https://sensuapp.org/downloads
[2]:  #repo
[3]:  #package
[4]:  https://sensuapp.org/mit-license
[5]:  configuration
[6]:  transport
[7]:  install-redis
[8]:  install-rabbitmq
