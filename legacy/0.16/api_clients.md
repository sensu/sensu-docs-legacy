---
version: "0.16"
category: "API"
title: "API clients"
---

# API Clients

List and delete client(s) information.

## `/clients` {#clients}

* `GET`: returns the list of clients

  - Parameters

    - `limit`

      - optional

      - value: integer

      - description: "The number of clients to return."

    - `offset`

      - optional

      - value: integer

      - depends: `limit`

      - description: "The number of clients to offset before returning items."

  - success: 200:

    ~~~ json
    [
        {
            "name": "i-334455",
            "address": "192.168.0.2",
            "subscriptions": [
                "chef-client",
                "sensu-server"
            ],
            "timestamp": 1324674972
        },
        {
            "name": "i-424242",
            "address": "192.168.0.3",
            "subscriptions": [
                "chef-client",
                "webserver",
                "memcached"
            ],
            "timestamp": 1324674956
        }
    ]
    ~~~

  - error: 500

## `/clients/:client` {#clients-client}

Example URL: `http://hostname:4567/clients/i-424242`

* `GET`: returns a client

  - success: 200:

    ~~~ json
    {
        "name": "i-424242",
        "address": "192.168.0.3",
        "subscriptions": [
            "chef-client",
            "webserver",
            "memcached"
        ],
        "timestamp": 1324674956
    }
    ~~~

  - missing: 404

  - error: 500

* `DELETE`: removes a client, resolving its current events (delayed action)

  - success: 202

  - missing: 404

  - error: 500

## `/clients/:client/history` {#clients-client-history}

Example URL: `http://hostname:4567/clients/i-424242/history`

* `GET`: returns the client history

  - success: 200:

    ~~~ json
    [
        {
            "check": "chef_client_process",
            "history": [
                0,
                1
            ],
            "last_execution": 1370725352,
            "last_status": 1
        },
        {
            "check": "keepalive",
            "history": [
              0,
              0,
              0
            ],
            "last_execution": 1370725351,
            "last_status": 0
        }
    ]
    ~~~

  - error: 500
