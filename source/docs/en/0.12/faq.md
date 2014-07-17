---
version: "0.12"
category: "Project"
title: "FAQ"
---

# FAQ

### What's the latest version of Sensu?

The latest version of Sensu is 0.12.

### Does Sensu run on Windows?

Yes. There are MSI packages for installing Sensu on Windows. You can use
the [package repository](http://repos.sensuapp.org/index.html) to
download the latest release.

### How do Sensu clients handle network issues or RabbitMQ outages?

The Sensu client is able to handle network issues and RabbitMQ outages
by attempting to reconnect to RabbitMQ on connection failure. The Sensu
client immediately attempts to reconnect. If unsuccessful, it will make
further attempts every 10 seconds, indefinitely.

### Do I need to synchronize my clocks?

Yes. As Sensu components use their local clocks for timestamps, they
must be synchronized. Not synchronizing your clocks may result in client
health false positives. Time synchronization can be done with NTP. See
https://help.ubuntu.com/12.04/serverguide/NTP.html for more details.

### How do I delete a client?

When you retire a client from your infrastructure it may still show up in
the Sensu dashboard as a `keepalive: no data from <host> in 300 seconds`
alert.

There are two methods for deleting clients: via the API or through the Sensu
Dashboard.

#### Using the API

``` bash
curl -X DELETE http://<sensu-api>/client/<node>
```

#### Using the Sensu Dashboard

Click **Clients** > (click on a client) > **Remove**

### How do I increase log verbosity?

You can toggle debug logging on and off by sending the Sensu process you
wish to debug a `USR1` signal. For example:

``` bash
$ ps aux | grep [s]ensu-server
sensu     5992  1.7  0.3 177232 24352 ...
$ kill -USR1 5992
```

### Any suggestions on naming conventions for metric plugins?

The `*service_name*-metrics` seems to be the de facto convention right now.

### Does Sensu require that Redis and RabbitMQ run locally?

No. Redis and RabbitMQ can run locally or on any remote host, so long as
the Sensu components can communicate with them.

### Which components of a Sensu system need access to Redis?

Only the Sensu server(s) and API communicate with Redis.

### Which components of a Sensu system need access to the RabbitMQ broker?

The core Sensu components (server, client, and API) require access to
the RabbitMQ broker.

### Can I run multiple Sensu servers?

Yes. You can run as many Sensu servers as you require. Check results are
distributed to Sensu servers in a round-robin fashion, allowing you to scale
out. Running more that one Sensu server is recommended.

### When I have multiple Sensu servers, which one will be the master?

The Sensu server master is reponsible for check request publishing. Master
election is automatic, and so is failover. No configuration is required.

### How do I register a Sensu client?

Sensu clients self-register when they start up. You do not have to maintain a list
of your clients. The Sensu clients must be configured correctly in order to run.

### Is there a configuration parameter to notify only every hour, even if the check has an interval of one minute?

In case your event handler is using the `sensu-handler` library you can
add `refresh` to your check definition.

### In case of a network failure, does the Sensu client queue results?

...

### Is there another way than the `remove` button in the web interface to remove clients and events from the dashboard?

...

### Do checks need to exist on the client?

No. They only need to be defined on the master server, but can defined on the
client to override the check attributes from those that are being set on
the server. Another case where a check needs to be present on the client
is when it is being defined as a standalone check. In `safe mode` the check
has to exist on both the client and the server.

### How do I configure a standalone-check?

Standalone-checks are configured in this example: http://blog.pkhamre.com/2012/03/21/sensu-standalone-checks/

### How do checks run (Ruby)?

Checks can be run on your hosts with the system-supplied Ruby or
the Sensu-supplied embedded Ruby. You can set the Ruby to be used when
Sensu is started by specifying the `EMBEDDED_RUBY` variable. This is
usually set using your operating system's init wrapper. For Sensu see the
`/etc/default/sensu` file.

### I use RVM, how can I get Sensu to find its dependencies in order to run?

You must use the Sensu embedded Ruby, by setting `EMBEDDED_RUBY=true`
in `/etc/default/sensu`. The Sensu init scripts will set GEM_PATH appropriately,
overriding RVM.

### My machine can't find Ruby. What should I do?

* Check that your `PATH` is set correctly. If you're using embedded
  Ruby, it should indicate an embedded Ruby binary path, for example
  `/opt/sensu/embedded/bin/ruby`.
* Try running a check whose content is only this command: `/usr/bin/env ruby -v` 
  and watch the output.
* Check your script's line-endings. On Linux/Unix machines you should
  ensure your line endings are correct using a command like
  `dos2unix`. This will ensure Microsoft Windows line endings, for
  example extraneous `^M` endings, are removed. 

### What is safe mode and how can I determine if it is enabled?

In safe mode a client will not run a check published by a server unless that
check is also defined on the client.

### According to  http://java.dzone.com/articles/getting-started-sensu, the conf.d/check_cron.json needs to exist on both the server and the client, why?

It no longer needs to. That information is outdated.

### Can someone tell me exactly what silencing an event is supposed to do? Maybe
I just incorrectly thought it prevented handlers from processing new
occurrences of the event.

Handlers are always executed, and the handler is expected to check the
`/stashes` under the Sensu API for silence entries.

Silencing an event involves creating an entry under `/stashes` in the
Sensu API. Handlers that inherit from the `sensu::plugin::handlers`
(from the `sensu-plugin` gem) will properly check for stashes and exit
without processing the event as normal.

### Why do you recommend a single SSL certificate for all Sensu Clients?

Please see this discussion on SSL certs, limitations, and workarounds: [ssl](ssl)

### What do I do if one of my machines is compromised and the Sensu client certificate is stolen?

Re-create your CA and client certificates, re-distribute to your RabbitMQ server, Sensu server, and Sensu clients.

Please see this discussion on SSL certs, limitations, and workarounds: [ssl](ssl)

### What is the Sensu equivalent of Zenoss' Thresholds and Escalate Count

Setting the `occurrences` attribute on a check definition instructs handlers to wait for a number of occurrences before taking action.
