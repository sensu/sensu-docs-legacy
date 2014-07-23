---
version: "0.13"
category: "API"
title: "Sensu API"
---

# Sensu API {#api}

The Sensu API provides access to the data that Sensu servers collect,
such as client information & current events. The API can also resolve
events and request check executions.

When using the Sensu [packages](packages), you can start the API on one or more
machines using the init script, eg. `/etc/init.d/sensu-api start`.

The API log can be found at `/var/log/sensu/sensu-api.log`.

## Configuration {#configuration}

The Sensu API requires some configuration, that can be in included in
`/etc/sensu/config.json`, or in its own configuration snippet, eg.
`/etc/sensu/conf.d/api.json`.

You must specify a port, all other configuration is optional. If you
wish to configure basic authentication, you must provide a user and a
password.

~~~ json
{
    "api": {
        "host": "localhost",
        "port": 4567,
        "user": "admin",
        "password": "secret",
        "bind": "0.0.0.0"
    }
}
~~~

## Endpoints {#endpoints}

### /aggregates {#aggregates}

List and delete check aggregates.

This endpoint provides the information needed to monitor a collection
of machines running a service.

See the [API aggregates documentation](api-aggregates) for more
information.

### /checks {#checks}

List locally defined checks and request executions.

See [API checks documentation](api-checks) for more information.

### /clients {#clients}

List and delete client(s) information.

See [API clients documentation](api-clients) for more information.

### /events {#events}

List and resolve current events.

See [API events documentation](api-events) for more information.

### /health {#health}

Check the status of the API's transport & Redis connections, and query
the transport's status (consumer and message counts).

See [API health documentation](api-health) for more information.

### /info {#info}

List the Sensu version and the transport and Redis connection
information (the same information that /health uses to determine
system health).

See [API info documentation](api-info) for more information.

### /stashes {#stashes}

Create, list, and delete stashes (JSON documents). Stashes are an HTTP
key/value data store.

See [API stashes documentation](api-stashes) for more information.
