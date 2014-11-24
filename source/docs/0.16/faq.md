---
version: "0.16"
category: "Project"
title: "FAQ"
---

# FAQ {#faq}

### What's the latest version of Sensu? {#whats-the-latest-version-of-sensu}

The latest version of Sensu is 0.16.

### Does Sensu run on Windows? {#does-sensu-run-on-windows}

Yes. There is an MSI package for installing Sensu on Windows. You can
learn more about it [here](packages).

### How do Sensu clients handle network issues or RabbitMQ outages? {#how-do-sensu-clients-handle-network-issues-or-rabbitmq-outages}

The Sensu client is able to handle network issues and RabbitMQ outages
by attempting to reconnect to RabbitMQ on connection failure. The
Sensu client immediately attempts to reconnect. If unsuccessful, it
will make further attempts every 10 seconds, indefinitely.

### Do I need to synchronize my clocks? {#do-i-need-to-synchronize-my-clocks}

Yes. As Sensu components use their local clocks for timestamps, they
must be synchronized. Not synchronizing your clocks may result in
client keepalive event false positives. Time synchronization can be
done with NTP. See
[here](https://help.ubuntu.com/12.04/serverguide/NTP.html) for more
details.

### How do I delete a client? {#how-do-i-delete-a-client}

When you retire a system from your infrastructure, that was running a
Sensu client, a keepalive event will be created for it until it has
been removed from the registry.

There are two methods for deleting clients: via the Sensu API or
through the Sensu Dashboard.

#### Using the API {#using-the-api}

~~~ bash
curl -X DELETE http://<sensu-api>/client/<node>
~~~

#### Using the Sensu Dashboard {#using-the-sensu-dashboard}

Click **Clients** > (click on a client) > **Remove**

Additionally, you can use the
[sensu-cli](https://rubygems.org/gems/sensu-cli) to delete clients.

~~~ bash
sensu-client delete NODE
~~~

### How do I increase log verbosity? {#how-do-i-increase-log-verbosity}

You can toggle debug logging on and off by sending the Sensu process a
`USR1` signal.

For example:

~~~ bash
$ ps aux | grep [s]ensu-server
sensu     5992  1.7  0.3 177232 24352 ...
$ kill -USR1 5992
~~~

You can adjust the process log level by setting `LOG_LEVEL` in
`/etc/default/sensu` to either `debug`, `info`, `warn` or `error`. You
will need to restart the Sensu process(s) after making the adjustment.

### Any suggestions on naming conventions for metric plugins? {#any-suggestions-on-naming-conventions-for-metric-plugins}

The `*service_name*-metrics` seems to be the convention.

### Does Sensu require that Redis and RabbitMQ run locally? {#does-sensu-require-that-redis-and-rabbitmq-run-locally}

No. Redis and RabbitMQ can run locally or on any remote host, so long
as the Sensu components can communicate with them.

### Which components of a Sensu system need access to Redis? {#which-components-of-a-sensu-system-need-access-to-redis}

Only the Sensu server(s) and API communicate with Redis.

### Which components of a Sensu system need access to the RabbitMQ broker? {#which-component-of-a-sensu-system-need-access-to-the-rabbitmq-broker}

The core Sensu components (server, client, and API) require access to
the RabbitMQ broker.

### Can I run multiple Sensu servers? {#can-i-run-multiple-sensu-servers}

Yes. You can run as many Sensu servers as you require. Check results
are distributed to Sensu servers in a round-robin fashion, allowing
you to scale out. Running more than one Sensu server is recommended.

### When I have multiple Sensu servers, which one will be the master? {#when-i-have-multiple-sensu-servers-which-one-will-be-the-master}

The Sensu server master is responsible for check request publishing.
Master election is automatic, and so is failover. No configuration is
required.

### How do I register a Sensu client? {#how-do-i-register-a-sensu-client}

Sensu clients self-register when they start up. You do not have to
maintain a list of your clients. The Sensu clients must be configured
correctly in order to run.

### Is there a configuration parameter to notify only every hour, even if the check has an interval of one minute? {#is-there-a-configuration-parameter-to-notify-only-once-per-hour}

If your event handler uses the `sensu-plugin` library,
`Sensu::Handler`, you can add `refresh` to your check definitions,
with a numeric value representing time in seconds.

### What is client safe mode? {#what-is-client-safe-mode}

In safe mode a client will not run a check published by a server
unless that check is also defined on the client.

### Do checks need to exist on the client? {#do-checks-need-to-exist-on-the-client}

The actual check scripts or binaries are executed on the client, they must 
exist on the filesystem for the Sensu client to execute.

They only need to be **defined** on the Sensu server(s), but can be
defined on the client to override certain check definition attributes.
Another case where a check needs to be defined on the client is when
it is being defined as a standalone check. 

If a client has `safe_mode` enabled, a check must be defined on both the 
client and the server.

In summary:
* Normal subscription based checks: Defined on the server only.
* Subscription checks with `safe_mode` enabled on the client: Defined on the server and client.
* Standlone checks: Defined on the client.

### How do I configure a standalone-check? {#how-do-I-configure-a-standalone-check}

Standalone-checks are configured in this example:
http://blog.pkhamre.com/2012/03/21/sensu-standalone-checks/

### How can I use the Sensu embedded Ruby for checks and handlers? {#how-can-I-use-the-sensu-embedded-ruby-for-checks-and-handlers}

You can use the embedded Ruby by setting `EMBEDDED_RUBY=true` in
`/etc/default/sensu`. The Sensu init scripts will set PATH and
GEM_PATH appropriately.

Note: Using the embedded Ruby fixes conflicts with RVM.

### My machine can't find Ruby. What should I do? {#my-machine-cant-find-ruby-what-should-i-do}

* Check that your `PATH` is set correctly. If you're using embedded
 Ruby, it should indicate an Sensu embedded binary path, for example
 `/opt/sensu/embedded/bin/`.
* Try running a check whose content is only this command:
 `/usr/bin/env ruby -v` and inspect the output.
* Check your script's line-endings. On Linux/Unix machines you should
 ensure your line endings are correct using a command like `dos2unix`.
 This will ensure Microsoft Windows line endings, for example
 extraneous `^M` endings, are removed.

### What is an API stash? {#what-is-an-api-stash}

[Stashes](api_stashes) allow you to store and retrieve JSON with the
[API](api). Sensu checks, handlers, etc. can utilize stashes as
needed. For instance, this would allow you to store Campfire
credentials in a stash on the API and then have a handler fetch the
stash. They are roughly analogous to data bags in Chef.

### What does silencing an event using the Sensu dashboard do? {#what-does-silencing-an-event-using-the-sensu-dashboard-do}

The Sensu dashboard creates API stashes to silence events using a
combination of client name and/or the check name. Handlers that
utilize the `sensu-plugin` library or similar functionality query the
Sensu API for silence stashes, and act accordingly.

### Why do you recommend a single SSL certificate for all Sensu Clients? {#why-do-you-recommend-a-single-ssl-certification-for-all-sensu-clients}

Learn more about Sensu and SSL certificates [here](certificates).

### What do I do if one of my machines is compromised and the Sensu client certificate is stolen? {#what-do-i-do-if-one-of-my-machines-is-compromised}

Re-create your CA and client certificates, re-distribute to your
RabbitMQ server, Sensu server, and Sensu clients.

Learn more about Sensu and SSL certificates [here](certificates).

### What is the Sensu equivalent of Zenoss' Thresholds and Escalate Count {#what-is-the-sensu-equivalen-of-zenoss-thresholds-and-escalate-count}

If your event handler uses the `sensu-plugin` library,
`Sensu::Handler`, you can add `occurrences` to your check definitions,
instructing handlers to wait for a number of occurrences before taking
action.

### I keep hearing about `occurences` and `refresh`, what are they? {#occurences-refresh}

`Occurences` and `refresh` are two particular pieces of [event data](event_data)
that the [Sensu::Handler](https://github.com/sensu/sensu-plugin/blob/master/lib/sensu-handler.rb)
class can interpret and filter against. If you use handlers that use the
`Sensu::Handler` class, they will see these values and act accordingly.

See the information in the [Checks](checks#common-custom-check-definitions)
section for more details on how checks can be configured to use them, and what
they do.

*Warning*: These `occurences` and `refresh` are simply arbirary key-values that
are available to handlers to use. If you are *not* using a handler that respects
them (for example, the trivial mail binary), no filtering will occur.

