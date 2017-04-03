---
title: "Mac OS X"
description: "User documentation for installing and operating Sensu on Mac OS X
  systems."
version: 0.27
weight: 4
info: "<strong>NOTE:</strong> this page contains reference documentation for
  installing and operating Sensu on Mac OS X systems. For instructions on
  installing or operating Sensu on other platforms, please visit the <a
  class='alert-link' href=../overview/platforms.html>supported platforms</a>
  page."
---

# Sensu on Mac OS X

- [Installing Sensu Core](#sensu-core)
  - [Download and install Sensu using the Sensu Universal .pkg file](#download-and-install-sensu-core)
- [Configure Sensu](#configure-sensu)
  - [Create the Sensu configuration directory](#create-the-sensu-configuration-directory)
  - [Example client configuration](#example-client-configuration)
  - [Example transport configuration](#example-transport-configuration)
  - [Configure the Sensu client `launchd` daemon](#configure-the-sensu-client-launchd-daemon)
- [Operating Sensu](#operating-sensu)
  - [Managing the Sensu client process with `launchctl`](#service-management)
  - [Interacting with Sensu via CLI](#interacting-with-sensu-via-cli)

## Install Sensu Core {#sensu-core}

Sensu Core is installed on Mac OS X systems via a native system installer
package (i.e. a .pkg file), which is available for download from the
[Sensu Downloads][1] page, and from [this repository][2].

_WARNING: Mac OS X packages are currently as a "beta" release. Support for
running Sensu on Mac OS X will be provided on a best-effort basis until further
notice._

### Download and install Sensu using the Sensu Universal .pkg file {#download-and-install-sensu-core}

1. Download Sensu from the [Sensu Downloads][1] page, or via the `curl` utility

   ~~~ shell
   curl -LO https://sensu.global.ssl.fastly.net/osx/sensu-0.27.1-1.pkg
   ~~~

   _NOTE: the Universal .pkg file supports OS X "Mavericks" (10.9) and newer.
   Mountain Lion users: please use [this installer][3]._

2. Install the package using the `installer` utility

   ~~~ shell
   sudo installer -pkg sensu-0.27.1-1.pkg -target /
   ~~~

3. Configure the Sensu client. **No "default" configuration is provided with
   Sensu**, so the Sensu Client will not start without the corresponding
   configuration. Please refer to the ["Configure Sensu" section][12] (below)
   for more information on configuring Sensu. **At minimum, the Sensu client
   will need a working [transport definition][13] and [client definition][14]**.

## Configure Sensu

By default, all of the Sensu services on Mac OS X systems will load
configuration from the following locations:

- `/etc/sensu/config.json`
- `/etc/sensu/conf.d/`

_NOTE: additional or alternative configuration file and directory locations may
be used by modifying Sensu's `launchd` daemon configuration XML and/or by
starting the Sensu services with the corresponding CLI arguments. For more
information, please see the [configure the Sensu client `launchd` daemon][4]
section, below._

The following Sensu configuration files are provided as examples. Please review
the [Sensu configuration reference documentation][5] for additional information
on how Sensu is configured.

### Create the Sensu configuration directory

In some cases, the default Sensu configuration directory (i.e.
`/etc/sensu/conf.d/`) is not created by the Sensu installer, in which case it is
necessary to create this directory manually.

~~~ shell
mkdir /etc/sensu/conf.d
~~~

### Example client configuration

1. Copy the following contents to a configuration file located at
   `/etc/sensu/conf.d/client.json`:

   ~~~ json
   {
     "client": {
       "name": "macosx-client",
       "address": "127.0.0.1",
       "environment": "development",
       "subscriptions": [
         "dev",
         "macosx-hosts"
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
   `/etc/sensu/conf.d/transport.json`:

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
   [transport definition specification][15]._

2. Please refer to the configuration instructions for the corresponding
   transport for configuration file examples (see [Redis][7], or [RabbitMQ][8]
   reference documentation).

### Configure the Sensu client `launchd` daemon

The Sensu Core .pkg package includes a Sensu client daemon configuration,
allowing Sensu to be run as a `launchd` job, or daemon. The OS X `launchd`
service and `launchctl` utility use a ["plist" file][9] (an XML-based
configuration file) to configure the `sensu-client` daemon run arguments (e.g.
`--log /var/log/sensu/sensu-client.log`).

1. To configure the Sensu client service wrapper, copy the default service
   definition file entitled `org.sensuapp.sensu-client.plist` to
   `/Library/LaunchDaemons/org.sensuapp.sensu-client.plist` and edit it with
   your favorite text editor.

   ~~~ shell
   sudo cp /opt/sensu/embedded/Cellar/sensu/0.27.0/Library/LaunchDaemons/org.sensuapp.sensu-client.plist /Library/LaunchDaemons/org.sensuapp.sensu-client.plist
   ~~~

2. This XML configuration file allows you to set Sensu client [CLI
   arguments][10]. The following example configuration file sets the Sensu
   client primary configuration file path to `/etc/sensu/config.json`, the Sensu
   configuration directory to `/etc/sensu/conf.d`, and the log file path to
   `/etc/sensu/sensu-client.log`.

   ~~~ xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC -//Apple//DTD PLIST 1.0//EN http://www.apple.com/DTDs/PropertyList-1.0.dtd>
   <plist version="1.0">
     <dict>
       <key>Label</key><string>org.sensuapp.sensu-client</string>
       <key>ProgramArguments</key>
       <array>
         <string>/opt/sensu/bin/sensu-client</string>
         <string>-c/etc/sensu/config.json</string>
         <string>-d/etc/sensu/conf.d</string>
         <string>-l/var/log/sensu/sensu-client.log</string>
       </array>
       <key>UserName</key><string>_sensu</string>
       <key>GroupName</key><string>_sensu</string>
       <key>RunAtLoad</key><true/>
       <key>KeepAlive</key><true/>
       <key>StandardOutPath</key><string>/var/log/sensu/sensu-client.log</string>
       <key>StandardErrorPath</key><string>/var/log/sensu/sensu-client.log</string>
     </dict>
   </plist>
   ~~~

## Operating Sensu

### Managing the Sensu client process with `launchctl` {#service-management}

Start or stop the Sensu client using the [`launchctl` utility][11]:

~~~ shell
sudo launchctl load -w /Library/LaunchDaemons/org.sensuapp.sensu-client.plist
sudo launchctl unload -w /Library/LaunchDaemons/org.sensuapp.sensu-client.plist
~~~

### Interacting with Sensu via CLI

Interacting with the any of the installed Sensu processes (e.g. `sensu-client`)
via CLI on Mac OS X requires running the processes as the `_sensu` user, which
is installed by the Sensu OS X installer package.

#### EXAMPLE

~~~ shell
$ sudo -u _sensu /opt/sensu/bin/sensu-client -V
0.27.1
~~~


[1]:  https://sensuapp.org/download
[2]:  https://sensu.global.ssl.fastly.net/osx/
[3]:  https://sensu.global.ssl.fastly.net/osx/sensu-0.27.1-1.mountainlion.pkg
[4]:  #configure-the-sensu-client-launchd-daemon
[5]:  ../reference/configuration.html
[6]:  ../reference/transport.html
[7]:  ../reference/redis.html#sensu-redis-configuration
[8]:  ../reference/rabbitmq.html#sensu-rabbitmq-configuration
[9]:  https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man5/plist.5.html
[10]: ../reference/configuration.html#sensu-service-cli-arguments
[11]: https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/launchctl.1.html
[12]: #configure-sensu
[13]: #example-transport-configuration
[14]: #example-client-configuration
[15]: ../reference/transport.html#transport-definition-specification
