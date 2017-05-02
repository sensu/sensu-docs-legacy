---
title: "Learn Sensu"
version: 0.26
weight: 2
---

# Learn Sensu in 15 Minutes

Sensu was designed to provide a comprehensive monitoring platform for monitoring
infrastructure (servers), services, application health, and business KPIs
&mdash; and to collect and analyze custom metrics. Although most Sensu Core and
Sensu Enterprise users eventually end up replacing several other monitoring
solutions and standardizing on Sensu &ndash; they didn't get there by learning
about every feature Sensu has to offer &ndash; they started with the basics.

This "Quick Start Guide" is not intended to teach you everything there is to
know about Sensu. This guide is designed to introduce you to the some basic
monitoring concepts using Sensu Core. It is our hope that this guide will whet
your appetite to learn more about Sensu, and feel the
[#monitoringlove][1].

## Overview

What will you learn how to do?

- [Exercise #1: Registering Sensu clients](#exercise-1)
- [Exercise #2: Configuring your first Sensu check](#exercise-2)
- [Exercise #3: Configuring your first Sensu handler](#exercise-3)
- [Exercise #4: Use the Sensu client input socket](#exercise-4)
- [Exercise #5: Configuring pubsub checks (using Sensu subscriptions)](#exercise-5)

## Quick start requirements

- Familiarity with a command-line interface & related tooling
  (e.g. text editor, curl)
- A standalone Sensu installation (preferably created using [the five minute
  install](the-five-minute-install))
- Access to the Internet for downloading plugins and communicating
  with external services
- Access to an SMTP server for sending alerts via email
- 15 minutes (the amount of time it should take to complete these exercises)

_WARNING: this guide assumes that you are using a standalone Sensu installation
that was setup by following the instructions in the [**the five minute
install**][2]. Please proceed accordingly._

-----

## Quick Start Guide

### Exercise #1: Registering Sensu clients {#exercise-1}

#### EXERCISE {#exercise-1-exercise}

One of the best parts of Sensu's design is automated registration and
deregistration of monitoring agents, and yet, one of the most frequently asked
questions about Sensu is _"how do I add new servers?"_. To demonstrate how this
works, let's observe what happens when the `sensu-client` on the local system
starts up for the first time.

1. Let's "reset" our testing environment by stopping the `sensu-client` and
   removing it from Sensu's registry.

   ~~~ shell
   sudo /etc/init.d/sensu-client stop
   ~~~

   Now let's query the [Clients API][3] to see how many clients are currently
   registered, and then let's delete them:

   ~~~ shell
   $ curl -s http://localhost:4567/clients | jq .
   [
     {
       "timestamp": 1458682194,
       "version": "0.26.0",
       "socket": {
         "port": 3030,
         "bind": "127.0.0.1"
       },
       "subscriptions": [
         "dev"
       ],
       "environment": "development",
       "address": "localhost",
       "name": "client-01"
     }
   ]
   ~~~

   If you've been following this guide you should see a very similar result as
   shown above &ndash; a single client named "test" is currently registered.
   Now let's delete it using the API:

   ~~~ shell
   $ curl -s -X DELETE localhost:4567/clients/client-01 | jq .
   {
     "issued": 1458683015
   }
   ~~~

   The Sensu API will respond with a JSON hash containing a timestamp (e.g.
    `"issued": 1458683015`), confirming that the client was deleted.

   _NOTE: if you try running the command again (i.e. attempting to delete a
   client that doesn't exist in Sensu's client registry), you will not see a
   timestamp because no action was taken._

2. Now let's confirm that our testing environment has been reset and that there
   are no clients registered:

   ~~~ shell
   $ curl -s localhost:4567/clients | jq .
   []
   ~~~

   The Sensu API should respond with an empty JSON array (i.e. `[]`), indicating
   that there are no clients currently registered with Sensu. If you still have
   one or more Sensu clients in your client registry, please repeat step 1 until
   there are no client registered with Sensu.

3. Now let's start the `sensu-client` again

   ~~~ shell
   sudo /etc/init.d/sensu-client start
   ~~~

   ...and then let's confirm that it automatically registers itself with the
   Sensu server.

   ~~~ shell
   $ curl -s localhost:4567/clients | jq .
   [
     {
       "timestamp": 1458684161,
       "version": "0.26.0",
       "socket": {
         "port": 3030,
         "bind": "127.0.0.1"
       },
       "subscriptions": [
         "dev"
       ],
       "environment": "development",
       "address": "localhost",
       "name": "client-01"
     }
   ]
   ~~~

   Our client is back!

#### SUMMARY {#exercise-1-summary}

**How does client registration work?** In practice, client registrations happens
when the Sensu server processes a client `keepalive` for a client that is not
already registered in the Sensu client registry (based on the configured client
`name` or `source` attribute).

**Learn more:**

- [Client registration & the client registry](#registration-and-registry)
- [Sensu client keepalives](clients#client-keepalives)

### Exercise #2: Configuring your first Sensu check {#exercise-2}

With a client registered in our Sensu installation, the server is now processing
`keepalive` messages. This helps us to know when the client has lost
connectivity, but what about the rest of the system? This is where
checks come into play.

Sensu Checks have two components: a plugin and a definition. Check
plugins are executables that are run by the Sensu client, and check
definitions are configuration that specifies how and when to run the
plugin.

Sensu's design allows for check execution to be scheduled by the
client or by the server. In this exercise we will install a check
plugin for monitoring availability of HTTP service, and
configure a check definition to execute the plugin. The scheduling of
this execution will be handled by the Sensu server.

1. Install nagios-plugins-http package to provide the check plugin

   ~~~ shell
   sudo yum install -y nagios-plugins-http
   ~~~

  You may be wondering, "why are we installing a Nagios plugin in a
  Sensu tutorial?"

  Good question! Sensu shares Nagios' check plugin specification,
  meaning existing check plugins compatible with Nagios can be used by
  Sensu without modification. In this case the check_http plugin is
  provided as a package by the Centos default distribution. Once
  installed, the plugin is available as `/usr/lib64/nagios/plugins/check_http`.

2. Let's execute the check plugin manually and see what happens:

   ~~~ shell
   $ /usr/lib64/nagios/plugins/check_http -I 127.0.0.1
   connect to address 127.0.0.1 and port 80: Connection refused
   HTTP CRITICAL - Unable to open TCP socket
   ~~~

   Here we can see that the check plugin output reflects failure to
   connect to port 80 on 127.0.0.1 (the localhost address).

   Beyond the human-readable output of the check plugin, the exit
   status code returned by the command (`$?`) is used by Sensu to
   determine if the check execution is indicative of an OK, WARNING or
   CRITICAL state.

   ~~~
   $ echo $?
   2
   ~~~

   In this case the plugin has returned an exit status of `2`, indicating
   a critical state. This aligns with the text output from the
   plugin. So far so good!

3. Now let's write a check definition which describes how and when to
   run this check plugin.

   Using the editor of your choice, create a JSON file in
   /etc/sensu/conf.d named "check_http.json" with the following
   content:

   ~~~ javascript
   {
     "checks": {
       "check_http": {
         "command": "/usr/lib64/nagios/plugins/check_http -I 127.0.0.1",
         "interval": 10,
         "subscribers": ["webserver"]
       }
     }
   }
   ~~~

   This definition describes a check named "check_http" which will run
   the specified command every 10 seconds on any Sensu clients with
   the subscription "webserver". Because this check defines
   subscribers it is considered a publish-subscribe check, or "pubsub"
   check, scheduled for execution by the Sensu server.

4. As we've added a new check definition, let's restart Sensu server
   and API services to update their configuration:

   ~~~ shell
   sudo systemctl restart sensu-{server,api}
   ~~~

   With these services restarted we should be able to observe via the
   API that the new check definition has been loaded:

   ~~~ json
   $ curl -s 127.0.0.1:4567/checks | jq .
   [
      {
        "command": "/usr/lib64/nagios/plugins/check_http -H 127.0.0.1",
        "interval": 10,
        "subscribers": [
        "webserver"
        ],
        "name": "check_http"
      }
   ]
   ~~~

   Now that the API reports this check has been loaded, the Sensu server
   should be scheduling execution of this check. We can verify this by
   watching the sensu-server log file:

   ~~~ json
   $ tail -f /var/log/sensu/sensu-server.log | grep check_http
   {"timestamp":"2017-03-16T17:36:46.947925+0000","level":"info","message":"publishing
   check request","payload":{"command":"/usr/lib64/nagios/plugins/check_http
   -H 127.0.0.1","name":"check_http","issued":1489685806},"subscribers":["webserver"]}
   ~~~

   The "publishing check request" message visible here indicates that
   the server is sending a request for check execution which the
   client will act on.

   We can verify that the client is acting on this check execution
   request by watching the sensu-client log file:

   ~~~ shell
   $ tail -f /var/log/sensu/sensu-client.log | grep check_http
   {"timestamp":"2017-03-16T17:40:23.639588+0000","level":"info","message":"received check request","check":{"command":"/usr/lib64/nagios/plugins/check_http -H 127.0.0.1","name":"check_http","issued":1489686023}}
   {"timestamp":"2017-03-16T17:40:23.643769+0000","level":"info","message":"publishing check result","payload":{"client":"localhost.localdomain","check":{"command":"/usr/lib64/nagios/plugins/check_http -H 127.0.0.1","name":"check_http","issued":1489686023,"executed":1489686023,"duration":0.004,"output":"connect to address 127.0.0.1 and port 80: Connection refused\nHTTP CRITICAL - Unable to open TCP socket\n","status":2}}}
   ~~~

   This pair of messages indicates that the client has received a
   request to execute the check, that the check has been executed and
   that the results of that check (the exit status code and output)
   have been published back to the results queue for later processing by the
   server.

#### SUMMARY {#exercise-2-summary}

**What is a Sensu Check?** A check is a combination of an executable
   command run by the client and configuration describing how and when
   to run the command. The client collects the output and exit status
   code of each check execution, publishing that information for
   processing by the server.

**Learn more**:

- [Check reference documentation](https://sensuapp.org/docs/latest/reference/checks.html)

### Exercise #3: Installing a Sensu handler {#exercise-3}

With the client executing check requests and returning results, the
server should now be processing these results and attempting to handle
them. Handling a check result can take many different forms, but in
this exercise we will configure the server to send an email alert.

The check definition can be used to indicate how the results from the
check execution should be handled, but our definition doesn't include
any such instructions. As a result, the check results will be passed
to a handler named "default".

1. Let's see what the server is doing with results destined for the
   "default" handler:

   ~~~ shell
   $ tail -f /var/log/sensu/sensu-server.log | grep default
   {"timestamp":"2017-03-16T17:44:54.510093+0000","level":"error","message":"unknown handler","handler_name":"default"}
   {"timestamp":"2017-03-16T17:45:05.340691+0000","level":"error","message":"unknown handler","handler_name":"default"}
   ~~~

   Because the "default" handler is unknown (unconfigured), the
   results of the check execution are effectively dropped with no
   further action. This means we need to configure the server with a
   handler to do something meaningful with these results.

2. Using the `sensu-install` program we can install plugins and
   extensions published by the Sensu community. Let's use
   `sensu-install` to install the `mailer` handler so we can receive
   alerts via email:

   ~~~ shell
   sudo sensu-install -p mailer
   ~~~

   With this plugin package installed, the `handler-mailer.rb`
   executable is now available at `/opt/sensu/embedded/bin/handler-mailer.rb`.

3. Similar to the check definition we wrote above, we will now need a
   definition to describe execution of the mailer handler.

   Using the editor of your choice, create a JSON file in
   `/etc/sensu/conf.d/handler_default.json` with the following
   content:

   ~~~ json
   {
     "handlers": {
       "default": {
         "command": "/opt/sensu/embedded/bin/handler-mailer.rb",
         "type": "pipe"
       }
     }
   }
   ~~~

   The mailer handler requires configuration to specify
   the email address and SMTP server details for sending an
   alert. Whereas our check and handler definitions have been
   configured under the "checks" and "handlers" scopes respectively,
   the configuration for the mailer handler will be provided under a
   top-level "mailer" scope.

   Using the editor of your choice, create a JSON file at
   `/etc/sensu/conf.d/mailer.json` using the following as a guide:

   ~~~ json
   {
       "mailer": {
           "mail_from": "alerts@example.com",
           "mail_to": "operators@example.com",
           "smtp_address": "smtp.gmail.com",
           "smtp_username": "alerts@example.com",
           "smtp_password": "your_password_here",
           "smtp_use_tls": true,
           "smtp_port": 465
       }
   }
   ~~~

   _NOTE_: The above is representative of configuration using Google's Gmail
   as the SMTP server. In place of the example values above, you must
   provide a valid values for `mail_from`, `mail_to`, `smtp_username`
   and `smtp_password`. If you are not a Gmail user, you may also need
   to adjust the `smtp_address`, `smtp_port` and `smtp_use_tls`
   values as appropriate for your SMTP host.

   At this point we have installed the `handler-mailer.rb` handler
   plugin, provided configuration for both the handler definition
   in `/etc/sensu/conf.d/handler_default.json`, and provided
   configuration details in `/etc/sensu/conf.d/mailer.json`.

   With this configuration in place we can restart the Sensu services
   and expect to see emails regarding our failing check:

   ~~~ shell
   sudo systemctl restart sensu-{server,api}
   ~~~

   After a successful restart of the sensu-server and sensu-api
   processes, we should see messages similar to this one in the
   sensu-server log file:

   ~~~ shell
   $ tail -f /var/log/sensu/sensu-server.log | grep default
   {"timestamp":"2017-03-20T19:12:51.356611+0000","level":"info","message":"handler output","handler":{"command":"/opt/sensu/embedded/bin/handler-mailer.rb","type":"pipe","name":"default"},"event":{"id":"efad9a7a-dca8-4ed8-aaac-32c429313988"},"output":["mail -- sent alert for localhost.localdomain/check_http to operators@example.com\n"]}
   ~~~

   And of course you should also see an email delivered to the
   mailbox of your `smtp_to` addressee!

#### SUMMARY {#exercise-3-summary}

**What is a Sensu handler?** A handler is a combination of an
  executable command run by the server and configuration describing
  how and when to run the command. The job of the handler is to take
  action on results generated by Sensu checks.

**Learn more**:

- [Handler reference documentation](https://sensuapp.org/docs/latest/reference/handlers.html)


### Exercise #4: Interacting with the Sensu API {#exercise-4}

Coming soon...


[1]:  http://twitter.com/hashtag/monitoringlove
[2]:  the-five-minute-install
[3]:  api-clients
