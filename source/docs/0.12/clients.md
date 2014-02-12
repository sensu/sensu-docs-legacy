---
version: "0.12"
category: "Configuration"
title: "Clients"
---

# Sensu clients

Each Sensu client requires client info, a definition, describing it.
Client info is published when the service starts, this is how the client
registers with Sensu. There are a few mandatory key-values, a unique
name for the client, an address, and its subscriptions. Subscriptions is
a list of the roles or responsibilities the server the Sensu client
resides on is responsible for, check requests are issued on these
subscriptions. Client info is included in [event data](events).

### Example

``` json
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
```

## Keepalives

Sensu clients publish keepalives to the server every 20 seconds.  When a keepalive hasn't been sent from a client in a specified threshold, the server will fire a handler.  The default threshold is to warn at 120 seconds and then goes critical at 180 seconds.  The handler that fires is the "default" handler.  You can specify your own thresholds and handler via the client configuration.


``` json
{
  "client": {
    "name": "i-424242",
    "address": "127.0.0.1",
    "keepalive": {
      "thresholds": {
        "warning": 60,
        "critical": 120
      },
      "handler": "keepalive"
    },
    "subscriptions": [
      "production",
      "webserver",
      "mysql"
    ]
  }
}
```

## Custom key-values

You can add custom client key-values, which will be included in event data, and can be used in check command token substitution.

### Example

``` json
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
```

Now you can use in sensu server json command:

```json
"command": "/etc/sensu/plugins/mysql/mysql-disk.rb -w 70 -c 80 -u :::mysql.user::: -p :::mysql.password:::"
```

where `:::mysql.user:::` and `:::mysql.password:::` is substitued by the json value
