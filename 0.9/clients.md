---
layout: default
title: Clients
description: Sensu clients
version: 0.9
---

# Sensu clients

Each Sensu client requires client info, a definition, describing it.
Client info is published when the service starts, this is how the client
registers with Sensu. There are a few mandatory key-values, a unique
name for the client, an address, and its subscriptions. Subscriptions is
a list of the roles or responsibilities the server the Sensu client
resides on is responsible for, check requests are issued on these
subscriptions. Client info is included in [event data](/{{ page.version
}}/events.html).

### Example

{% highlight json %}
{
  "client": {
    "name": "i-424242",
    "address": "127.0.0.1",
    "subscriptions": [
      "production",
      "webserver",
      "mysql"
    ]
  }
}
{% endhighlight %}

## Custom key-values
You can add custom client key-values, which will be included in event data, and can be used in check command token substitution.

### Example

{% highlight json %}
{
  "client": {
    "name": "i-424242",
    "address": "127.0.0.1",
    "subscriptions": [
      "production",
      "webserver",
      "mysql"
    ],
    "mysql": {
      "host": "localhost",
      "port": 3306,
      "user": "foo",
      "password": "bar"
    }
  }
}
{% endhighlight %}

