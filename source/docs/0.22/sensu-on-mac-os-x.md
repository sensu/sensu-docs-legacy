---
version: 0.22
category: "Installation Guide"
title: "Sensu on Mac OS X"
---

# Sensu on Mac OS X

- [Installing Sensu Core](#sensu-core)
  - [Download and install Sensu using the Sensu Universal .pkg file](#download-and-install-sensu-core)
- [Configure Sensu](#configure-sensu)
  - [Example client configuration](#example-client-configuration)
  - [Example transport configuration](#example-transport-configuration)
  - [Configure the Sensu client `launchd` daemon](#configure-the-sensu-client-launchd-daemon)
- [Operating Sensu](#operating-sensu)
  - [Managing the Sensu client process](#service-management)

## Install Sensu Core {#sensu-core}

Sensu Core is installed on Mac OS X systems via a native system installer
package (i.e. a .pkg file), which is available for download from the
[Sensu Downloads][download] page, and from [this repository][osx-repo].

_WARNING: Mac OS X packages are currently as a "beta" release. Support for running
Sensu on Mac OS X will be provided on a best-effort basis until further notice._

### Download and install Sensu using the Sensu Universal .pkg file {#download-and-install-sensu-core}

1. Download Sensu from the [Sensu Downloads][download] page, or via the `curl`
   utility

   ~~~ shell
   curl -LO https://core.sensuapp.com/osx-unstable/sensu-0.22.0-1.pkg
   ~~~

   _NOTE: the Universal .pkg file supports OS X "Mavericks" (10.9) and newer.
   Mountain Lion users: please use [this installer][pkg-mountainlion]._

2. Install the package using the `installer` utility

   ~~~ shell
   sudo installer -pkg sensu-0.22.0-1.pkg -target /
   ~~~

## Configure Sensu

By default, all of the Sensu services on Mac OS X systems will load
configuration from the following locations:

- `/etc/sensu/config.json`
- `/etc/sensu/conf.d/`

_NOTE: additional or alternative configuration file and directory locations may
be used by modifying Sensu's service configuration XML and/or by starting the
Sensu services with the corresponding CLI arguments. For more information,
please consult the [Sensu Configuration](configuration) reference
documentation._

The following Sensu configuration files are provided as examples. Please review
the [Sensu configuration reference documentation](configuration) for additional
information on how Sensu is configured.

### Example client configuration

1. Copy the following contents to a configuration file located at
   `/etc/sensu/conf.d/client.json`:

   ~~~ json
   {
     "client": {
       "name": "macosx",
       "address": "localhost",
       "environment": "development",
       "subscriptions": [
         "dev",
         "macosx"
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

### Configure the Sensu client `launchd` daemon

The Sensu client installer package for Mac OS X provides a `plist` file for
configuring and running the Sensu client as a `launchd` job or daemon.

#### Sensu client daemon `plist` configuration

The Sensu Core .pkg package includes a Sensu client daemon configuration,
allowing Sensu to be run as a `launchd` job, or daemon. The OS X `launchd`
service and `launchctl` utility use a ["plist" file][plist] (an XML-based
configuration file) to configure the `sensu-client` daemon run arguments (e.g.
`--log /var/log/sensu/sensu-client.log`).

1. To configure the Sensu client service wrapper, copy the default service
   definition file entitled `org.sensuapp.sensu-client.plist` to
   `/etc/sensu/org.sensuapp.sensu-client.plist` and edit it with your favorite
   text editor.

   ~~~ shell
   sudo cp /opt/sensu/embedded/Cellar/sensu/0.22.0/Library/LaunchDaemons/org.sensuapp.sensu-client.plist /etc/sensu/org.sensuapp.sensu-client.plist
   ~~~

2. This XML configuration file allows you to set Sensu client [CLI
   arguments][cli-args]. The following example configuration file sets the Sensu
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

### Managing the Sensu client process {#service-management}

Start or stop the Sensu client using the [`launchctl` utility][launchctl]:

~~~ shell
sudo launchctl load -w /etc/sensu/org.sensuapp.sensu-client.plist
sudo launchctl unload -w /etc/sensu/org.sensuapp.sensu-client.plist
~~~


[download]:             https://sensuapp.org/download
[osx-repo]:             https://core.sensuapp.com/osx-unstable/
[pkg-universal]:        https://core.sensuapp.com/osx-unstable/sensu-0.22.0-1.pkg
[pkg-mountainlion]:     https://core.sensuapp.com/osx-unstable/sensu-0.22.1-1.mountainlion.pkg
[mit-license]:          https://sensuapp.org/mit-license
[cli-args]:             configuration#sensu-service-cli-arguments
[launchctl]:            https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/launchctl.1.html
[plist]:                https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man5/plist.5.html
