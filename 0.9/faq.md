---
layout: default
title: FAQ
description: Sensu FAQ for version 0.9
version: 0.9
---

# FAQ

<br />

* This will become a table of contents (this text will be scraped).
{:toc}

## What's the latest version of Sensu?

The latest version of Sensu is {{ site.current_version }}.

## Does Sensu run on Windows?

Yes. There are MSI packages for installing Sensu on Windows. You can use
http://repos.sensuapp.org/index.html to download the latest release.

## How do Sensu clients handle network issues or RabbitMQ outages?

The Sensu client is able to handle network issues and RabbitMQ outages
by attempting to reconnect to RabbitMQ on connection failure. The Sensu
client immediately attempts to reconnect, if unsuccessful, it will make
further attempts every 10 seconds, indefinitely.

## Do I need to synchronize my clocks?

Yes. As Sensu components use their local clocks for timestamps, they
must be synchronized. Not synchronizing your clocks may result in client
health false positives. Time synchronization can be done with NTP, see
https://help.ubuntu.com/12.04/serverguide/NTP.html for more details.

## How do I delete a client?

When you retire a client from your infrastructure it may still show up in
the Sensu dashboard as a `keepalive: no data from <host> in 300 seconds`
alert.

There are two methods for deleting clients: API or through the Sensu
Dashboard.

### Using the API

{% highlight bash %}
curl -X DELETE http://<sensu-api>/client/<node>
{% endhighlight %}

### Using the Sensu Dashboard

    Click **Clients** > (click on a client) > **Remove**

## How do I increase log verbosity?

You can toggle debug logging on and off by sending the Sensu process you
wish to debug a `USR1` signal. For example:

{% highlight bash %}
    $ ps aux | grep [s]ensu-server
    sensu     5992  1.7  0.3 177232 24352 ...
    $ kill -USR1 5992
{% endhighlight %}

## Any suggestions on naming conventions for metrics?

The `metrics-*name*` seems to be the de facto convention right now.

## Does Sensu require that Redis and RabbitMQ run locally?

No. Redis and RabbitMQ can run locally or on any remote host, so long as
the server(s) and clients can communicate with them.

## Which components of a Sensu system need access to Redis?

Only the Sensu master server actively communicates with Redis. Any Sensu
server which may become master will need access the Redis server in
order to function as the master.

## Which components of a Sensu system need access to the RabbitMQ broker?

As Sensu depends on AMQP as its messaging bus, all server(s) and clients
in a Sensu system require access to the RabbitMQ broker.

## When I have multiple Sensu servers, which one will be the master?

First, it does not matter how many servers are running, and second they
will automatically elect a master including a failover.

## How do I get the Sensu server to create another client without manually doing it?

When a new client joins the Sensu server, the server configuration does not have to
be changed at all. That's one of the cool things about Sensu. The
Sensu client only needs to know the server and registers with it upon
startup. In more detail, the server is creating channels in RabbitMQ and
Sensu clients are connecting to those channels. When a new instance with
the Sensu client on it is being bootstrapped, and this client has a
particular configuration which points to the server's RabbitMQ, there is no
need to do anything manually on the server.

## Can someone show me an example of how they are listing multiple clients on the server?

See the answer in "How do I get the Sensu server to create another
client without manually doing it?". There is no need to
manually list clients on the server. Each client has its own
configuration, that only needs to point to the server. The server
publishes checks and only learns about the client and only learns about
clients as they report back with their check and keepalive results.

## How do I register the xmpp handler?

You should call it with the `pipe` type.

## Is there a configuration parameter to notify only every hour, even if the check has an interval of one minute?

In case your event handler is using the `sensu-handler` library you can
add `refresh` to your check definition.

## In case of a network failure, does the Sensu client queue results?

...

## Is there another way than the `remove` button in the web interface to remove clients and events from the dashboard?

...

## Do checks need to exist on the client?

No, the only need to be defined on the servers, but can defined on the
client to override the check attributes from those that are being set on
the server. Another case where a check needs to be present on the client
is, when it is being defined as a standalone-check, then it does not be
defined on the server. In `safe mode` the check has to exist on
both the client and the server.

## How do I configure a standalone-check?

Standalone-checks are configured in this example: http://blog.pkhamre.com/2012/03/21/sensu-standalone-checks/

## What is safe mode and how can I determine if it is enabled?

...

## According to  http://java.dzone.com/articles/getting-started-sensu, the conf.d/check_cron.json needs to exist on both, the server and the client, why?

It no longer needs to, that information is outdated.

## Can someone tell me exactly what silencing an event is supposed to do? Maybe I just incorrectly thought it prevented handlers from processing new occurrences of the event.

Handlers are always executed, and the handler is expected to check the
`/stashes` under the Sensu API for silence entries.

Silencing an event involves creating an entry under `/stashes` in the
Sensu API. Handlers that inherit from the `sensu::plugin::handlers`
(from the `sensu-plugin` gem) will properly check for stashes and exit
without processing the event as normal.

## Why do you recommend a single SSL certificate for all Sensu Clients?

Please see this discussion on SSL certs, limitations, and workarounds: [ssl](/{{ page.version }}/ssl.html)

## What do I do if one of my machines is compromised and the Sensu client certificate is stolen?

Re-create your CA and client certificates, re-distribute to your RabbitMQ server, Sensu server, and Sensu clients.

Please see this discussion on SSL certs, limitations, and workarounds: [ssl](/{{ page.version }}/ssl.html)

## What is the Sensu equivalent of Zenoss' Thresholds and Escalate Count

Setting the `occurrences` attribute on a check definition instructs handlers to wait for a number of occurrences before taking action.
