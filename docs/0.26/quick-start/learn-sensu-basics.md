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

- Familiarity with a modern command-line interface & related tooling
- A standalone Sensu installation (preferably created using [the five minute
  install](the-five-minute-install))
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

Coming soon...

### Exercise #3: Configuring your first Sensu handler {#exercise-3}

Coming soon...

### Exercise #4: Using the Sensu client input socket {#exercise-4}

Coming soon...

### Exercise #5: Configuring pubsub checks (using Sensu subscriptions) {#exercise-5}

Coming soon...


[1]:  http://twitter.com/hashtag/monitoringlove
[2]:  the-five-minute-install
[3]:  api-clients
