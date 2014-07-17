---
version: "0.11"
category: "API"
title: "The Sensu API"
---

# The Sensu API

The Sensu API provides access to the data Sensu servers collect, such as clients & events.

The API is capable of requesting checks be executed and can resolve events.

When using the Sensu packages, you may start the API on one or more boxes with `/etc/init.d/sensu-api start`.  Logs for the api are located at `/var/log/sensu/sensu-api.log`.

## Configuration

The sensu-api is generally configured in the `/etc/sensu/config.json`; refer to [installing sensu](installing_sensu) for more information.  The available options for the api configuration are as follows:

``` json
{
  "api": {
    "host": "localhost",
    "port": 4567,
    "user": "admin",
    "password": "shhh",
    "bind": "0.0.0.0"
  }
}
```

## Aggregates

The aggregate endpoints allows you to list and delete aggregate checks.

base-url `http://localhost:4567/aggregates`

See [Aggregates Endpoint Documentation](api-aggregates) for more information.

## Checks

The check endpoints allow you to list and issue checks.

base-url `http://localhost:4567/checks`

See [Checks Endpoint Documentation](api-checks) for more information.

## Clients

The client endpoints allows you to list, delete and get the histroy of clients.

base-url `http://localhost:4567/clients`

See [Clients Endpoint Documentation](api-clients) for more information. 

## Events

The event endpoints allows you to list and resolve events.

base-url `http://localhost:4567/events`

See [Events Endpoint Documentation](api-events) for more information.

## Health (0.9.13)

The health endpoint checks to see if the api can connect to redis and rabbitmq.  It takes parameters for minimum consumers and maximum messages and checks rabbitmq.

base-url `http://localhost:4567/health`

See [Health Endpoint Documentation](api-health) for more information.

## Info

The info endpoint will return the Sensu version along with rabbitmq and redis information.

base-url `http://localhost:4567/info`

See [Info Endpoint Documentation](api-info) for more information.

## Stashes

The stashes endpoints allows you to create, list and delete stashes.

base-url `http://localhost:4567/stashes`

See [Stashes Endpoint Documentation](api-stashes) for more information.

