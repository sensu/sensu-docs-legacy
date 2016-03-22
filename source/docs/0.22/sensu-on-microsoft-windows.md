---
version: 0.22
category: "Installation Guide"
title: "Install Sensu on Microsoft Windows"
---

# Sensu on Microsoft Windows

- [Installing Sensu Core](#sensu-core)
  - [Download and install Sensu using the Sensu MSI](#download-and-install-sensu-core)
- [Configure Sensu](#configure-sensu)
  - [Create the Sensu configuration directory](#create-the-sensu-configuration-directory)
  - [Example client configuration](#example-client-configuration)
  - [Example transport configuration](#example-transport-configuration)
  - [Configure the Sensu client Windows service wrapper](#configure-the-sensu-client-windows-service-wrapper)
  - [Install the Sensu client Windows service](#install-the-sensu-client-windows-service)
- [Operating Sensu](#operating-sensu)
  - [Managing the Sensu client Windows service](#service-management)

## Install Sensu Core {#sensu-core}

Sensu Core is installed on Microsoft Windows systems via a native system
installer package (i.e. a .msi file), which is available for download from the
[Sensu Downloads][download] page, and from [this repository][msi-repo].

### Download and install Sensu using the Sensu MSI {#download-and-install-sensu-core}

1. Download Sensu from the [Sensu Downloads][download] page, or by using this
   link:

   [https://core.sensuapp.com/msi/sensu-0.22.1-1.msi](https://core.sensuapp.com/msi/sensu-0.22.1-1.msi)

2. Double-click the `sensu-0.22.1-1.msi` installer package to launch the
   installer, accept the Sensu Core [MIT License][mit-license] and install Sensu
   using the default settings (e.g. install location, etc).

   _WARNING: changing the default installation path from `C:\opt` is strongly
   discouraged._

## Configure Sensu

By default, all of the Sensu services on Microsoft Windows systems will load
configuration from the following locations:

- `C:\opt\sensu\config.json`
- `C:\ops\sensu\conf.d\`

_NOTE: in general, where references to configuration file locations found
elsewhere in the Sensu documentation suggest paths beginning with `/etc/sensu`,
these will correspond to `C:\opt\sensu` on Microsoft Windows systems. Additional
or alternative configuration file and directory locations may be used by
modifying Sensu's service configuration XML and/or by starting the Sensu
services with the corresponding CLI arguments. For more information, please
consult the [Sensu Configuration](configuration) reference documentation._

The following Sensu configuration files are provided as examples. Please review
the [Sensu configuration reference documentation](configuration) for additional
information on how Sensu is configured.

### Create the Sensu configuration directory

In some cases, the default Sensu configuration directory (i.e.
`C:\opt\sensu\conf.d\`) is not created by the Sensu MSI installer, in which case
it is necessary to create this directory manually.

~~~ cmd
mkdir C:\opt\sensu\conf.d\
~~~

### Example client configuration

1. Copy the following contents to a configuration file located at
   `C:\opt\sensu\conf.d\client.json`:

   ~~~ json
   {
     "client": {
       "name": "windows",
       "address": "localhost",
       "environment": "development",
       "subscriptions": [
         "dev",
         "windows"
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
connect to the configured [Sensu Transport](transport). Please refer to the
configuration instructions for the corresponding transport for configuration
file examples (see [Install Redis](install-redis), or [Install
RabbitMQ](install-rabbitmq)).

### Configure the Sensu client Windows service wrapper

The Sensu Core MSI package includes a Sensu client service wrapper, allowing
Sensu to be registered as a Windows service. The Sensu client service wrapper
uses an XML configuration file to configure the `sensu-client` run arguments
(e.g. `--log C:\opt\sensu\sensu-client.log`).

To configure the Sensu client service wrapper, edit the service definition file
at `C:\opt\sensu\bin\sensu-client.xml` with your favorite text editor. This XML
configuration file allows you to set [Sensu client CLI arguments][cli-args]. The
following example configuration file sets the Sensu client primary
configuration file path to `C:\opt\sensu\config.json`, the Sensu configuration
directory to `C:\opt\sensu\conf.d`, and the log file path to
`C:\opt\sensu\sensu-client.log`.

~~~ xml
<!--
  Windows service definition for Sensu
-->
<service>
  <id>sensu-client</id>
  <name>Sensu Client</name>
  <description>This service runs a Sensu client</description>
  <executable>C:\opt\sensu\embedded\bin\ruby</executable>
  <arguments>C:\opt\sensu\embedded\bin\sensu-client -c C:\opt\sensu\config.json -d C:\opt\sensu\conf.d -l C:\opt\sensu\sensu-client.log</arguments>
</service>
~~~

### Install the Sensu client Windows service

1. Obtain the hostname or IP address of the Windows system where the Sensu
   client is installed. For the purpose of this example, we will assume
   `10.0.1.100` is our IP address.

2. Open a Command Prompt and use the [Windows SC][sc] utility to create the
   Windows service for the Sensu client:

   ~~~ cmd
   sc \\10.0.1.100 create sensu-client start= delayed-auto binPath= c:\opt\sensu\bin\sensu-client.exe DisplayName= "Sensu Client"
   ~~~

   _NOTE: the space between the equals (=) and the values is required._

## Operating Sensu

### Managing the Sensu client Windows service {#service-management}

To manually start and stop the Sensu client Windows service, use the
[Services.msc][msc] utility, or via the Command Prompt.

- Start or stop the Sensu client

  ~~~ shell
  sc sensu-client start
  sc sensu-client stop
  ~~~


[download]:             https://sensuapp.org/download
[msi-repo]:             https://core.sensuapp.com/msi/
[mit-license]:          https://sensuapp.org/mit-license
[cli-args]:             configuration#sensu-service-cli-arguments
[sc]:                   https://technet.microsoft.com/en-us/library/bb490995.aspx
[msc]:                  https://technet.microsoft.com/en-us/library/cc755249.aspx
