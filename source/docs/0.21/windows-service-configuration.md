---
version: 0.21
category: "Windows Guide"
title: "Configure Sensu on Windows"
success: "<strong>NOTE:</strong> this is part 2 of 2 steps in the Sensu
  Windows Guide. For the best results, please make sure to follow the
  instructions carefully and complete all of the steps in each section before
  moving on."
---

# Overview

The Sensu Core MSI package includes a Sensu client service wrapper, allowing Sensu to be registered as a Windows service. The Sensu client service wrapper uses an XML configuration file, to configure the `sensu-client` run arguments, e.g. `--log C:\opt\sensu\sensu-client.log`.

The following instructions will help you to:

- Configure the Sensu client to connect to a remote [Sensu installation](installation-overview)
- Configure the Sensu client service wrapper
- Install and start the Sensu client Windows service
- Observe the operation of the Sensu client

# Configure the Sensu client on Windows

## Create the configuration directory

Create the configuration directory at `C:\opt\sensu\conf.d`, using Windows Explorer or Command Prompt with the following command.

~~~ plain
mkdir C:\opt\sensu\conf.d
~~~

## Configure connections

As mention in the [Sensu installation guide](installation-overview), all Sensu services use a transport (by default, this is RabbitMQ) to communicate with one another. In order for the Sensu client on Windows to communicate with the transport, we need to tell it where to find the transport. Create the primary configuration file for the Sensu client by copying the following contents using your favorite text editor to `C:\opt\sensu\config.json` (replacing `YOUR_RABBITMQ_HOST_IP` with the IP address of your RabbitMQ machine).

~~~ json
{
  "rabbitmq": {
    "host": "YOUR_RABBITMQ_HOST_IP",
    "vhost": "/sensu",
    "user": "sensu",
    "password": "secret"
  }
}
~~~

## Configure the Sensu client

Each Sensu client requires its own client definition, containing a set of required attributes (name, address, subscriptions). To configure the Sensu client on Windows, copy the following example configuration to `C:\opt\sensu\conf.d\client.json` using your text editor of choice.

_NOTE: this example file configures the Sensu client with client metadata, including a unique name, an address (any string), and its [Sensu Subscriptions](clients#what-are-sensu-clients)._

~~~ shell
{
  "client": {
    "name": "windows",
    "address": "localhost",
    "subscriptions": [
      "windows"
    ]
  }
}
~~~

# Configure the Sensu client service wrapper

To configure the Sensu client service wrapper, edit the service definition file at `C:\opt\sensu\bin\sensu-client.xml` with your favorite text editor. This XML configuration file allows you - the user - to set Sensu client CLI arguments. The following example configuration file sets the Sensu client primary configuration file to `C:\opt\sensu\config.json`, the configuration directory to `C:\opt\sensu\conf.d`, and the log file to `C:\opt\sensu\sensu-client.log`.

_NOTE: you should only be adjusting the Sensu client command line arguments in this file (e.g. `--log_level debug`)._

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

For a full list of Sensu client command line arguments and their descriptions, run the following command.

~~~ powershell
C:\opt\sensu\embedded\bin\sensu-client -h
~~~

# Install and start the Windows service

## Create the service

Open a Command Prompt and use the Windows SC command to create the Windows service for the Sensu client (replacing `HOSTNAME_OR_IP` with the hostname or IP address of your Windows machine).

_NOTE: the space between the equals(=) and the values is required._

~~~ powershell
sc \\HOSTNAME_OR_IP create sensu-client start= delayed-auto binPath= c:\opt\sensu\bin\sensu-client.exe DisplayName= "Sensu Client"
~~~

## Start the service

Start the Sensu Client Windows service from the Services.msc panel or the Command Prompt.

# Observe the Sensu client

Congratulations! By now you should have successfully installed and configured the Sensu client on Windows! Now let's observe it in operation.

The Sensu client log file can be found at `C:\opt\sensu\sensu-client.log`.

You can use your favorite text editor to view the log file.

_NOTE: log events will continue to be written to the log file while you view it, you may need to re-open the file with your editor in order to see the updates._
