---
layout: default
title: The Sensu API
description: The Sensu API
version: '0.11'
---

<div class="page-header">
  <h1>The Sensu API<small></small></h1>
</div>

The Sensu API provides access to the data Sensu servers collect, such as clients & events.

The API is capable of requesting checks be executed and can resolve events.

When using the Sensu packages, you may start the API on one or more boxes with `/etc/init.d/sensu-api start`.  Logs for the api are located at `/var/log/sensu/sensu-api.log`.

## Configuration
The sensu-api is generally configured in the `/etc/sensu/config.json`; refer to <a href="/{{ page.version }}/installing_sensu.html">installing sensu</a> for more information.  The available options for the api configuration are as follows:

{% highlight json %}
{
  "api": {
    "host": "localhost",
    "port": 4567,
    "user": "admin",
    "password": "shhh",
    "bind": "0.0.0.0"
  }
}
{% endhighlight %}

## Aggregates
The aggregate endpoints allows you to list and delete aggregate checks.

base-url `http://localhost:4567/aggregates`
<li><a href="/{{ page.version }}/api/aggregates.html">Aggregates Endpoint Documentation</a></li>

## Checks
The check endpoints allow you to list and issue checks.

base-url `http://localhost:4567/checks`
<li><a href="/{{ page.version }}/api/checks.html">Checks Endpoint Documentation</a></li>

## Clients
The client endpoints allows you to list, delete and get the histroy of clients.

base-url `http://localhost:4567/clients`
<li><a href="/{{ page.version }}/api/clients.html">Clients Endpoint Documentation</a></li>

## Events
The event endpoints allows you to list and resolve events.

base-url `http://localhost:4567/events`
<li><a href="/{{ page.version }}/api/events.html">Events Endpoint Documentation</a></li>

## Health (0.9.13)
The health endpoint checks to see if the api can connect to redis and rabbitmq.  It takes parameters for minimum consumers and maximum messages and checks rabbitmq.

base-url `http://localhost:4567/health`
<li><a href="/{{ page.version }}/api/health.html">Health Endpoint Documentation</a></li>

## Info
The info endpoint will return the Sensu version along with rabbitmq and redis information.

base-url `http://localhost:4567/info`
<li><a href="/{{ page.version }}/api/info.html">Info Endpoint Documentation</a></li>

## Stashes
The stashes endpoints allows you to create, list and delete stashes.

base-url `http://localhost:4567/stashes`
<li><a href="/{{ page.version }}/api/stashes.html">Stashes Endpoint Documentation</a></li>
