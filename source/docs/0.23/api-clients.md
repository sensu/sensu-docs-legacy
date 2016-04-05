---
version: 0.23
category: "API Docs"
title: "Clients API"
next:
  url: "api-checks"
  text: "Checks API"
---

# Sensu Clients API

List and delete client(s) information.

## API Definition

`/clients` (GET)
: desc.
  : Returns a list of clients.

: example url
  : http://hostname:4567/clients

: parameters
  : - `limit`:
      - **required**: false
      - **type**: Integer
      - **description**: The number of clients to return.
    - `offset`:
      - **required**: false
      - **type**: Integer
      - **depends**: `limit`
      - **description**: The number of clients to offset before returning items.

: response type
  : Array

: response codes
  : - **Success**: 200 (OK)
    - **Error**: 500 (Internal Server Error)

: output
  : ~~~ json
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

`/clients/:client` (GET)
: desc.
  : Returns a client.

: example url
  : http://hostname:4567/clients/i-424242

: response type
  : Hash

: response codes
  : - **Success**: 200 (OK)
    - **Missing**: 404 (Not Found)
    - **Error**: 500 (Internal Server Error)

: output
  : ~~~ json
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

`/clients` (POST)
: desc
  : Create or update client data (e.g. [Sensu JIT clients](clients#jit-clients)).

: example URL
  : http://hostname:4567/clients

: payload
  : ~~~ json
    {
        "name": "gateway-router",
        "address": "192.168.0.1",
        "subscriptions": [
            "network",
            "snmp"
        ],
        "environment": "production"
    }
    ~~~

: response codes
  : - **Success**: 201 (Created)
    - **Malformed**: 400 (Bad Request)
    - **Error**: 500 (Internal Server Error)

`/clients/:client` (DELETE)
: desc.
  : Removes a client, resolving its current events. (delayed action)

: example url
  : http://hostname:4567/clients/i-424242

: response codes
  : - **Success**: 202 (Accepted)
    - **Missing**: 404 (Not Found)
    - **Error**: 500 (Internal Server Error)

`/clients/:client/history` (GET)
: desc.
  : Returns the history for a client.

: example url
  : http://hostname:4567/clients/i-424242

: response type
  : Array

: response codes
  : - **Success**: 200 (OK)
    - **Error**: 500 (Internal Server Error)

: output
  : ~~~ json
    [
        {
            "check": "chef_client_process",
            "history": [
                0,
                1
            ],
            "last_execution": 1370725352,
            "last_status": 1,
            "last_result": {
                "name": "chef_client_process",
                "command": "check-procs -p chef-client -W 1",
                "subscribers": [
                    "production"
                ],
                "interval": 60,
                "issued": 1389374667,
                "executed": 1389374667,
                "output": "WARNING Found 0 matching processes\n",
                "status": 1,
                "duration": 0.005
            }
        },
        {
            "check": "keepalive",
            "history": [
                0,
                0,
                0
            ],
            "last_execution": 1389374665,
            "last_status": 0,
            "last_result": {
                "name": "keepalive",
                "thresholds": {
                    "warning": 120,
                    "critical": 180
                },
                "issued": 1389374665,
                "executed": 1389374665,
                "output": "Keepalive sent from client 11 seconds ago",
                "status": 0
            }
        }
    ]
    ~~~
