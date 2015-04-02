---
version: 0.17
category: "API Docs"
title: "Clients API"
next:
  url: "api-checks"
  text: "Checks API"
---

# Overview

List and delete client(s) information.

# API Definition

`/clients` (GET)
: desc.
  : Returns a list of clients.

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

`/clients/:client` (DELETE)
: desc.
  : Removes a client, resolving its current events. (delayed action)

: response codes
  : - **Success**: 202 (Accepted)
    - **Missing**: 404 (Not Found)
    - **Error**: 500 (Internal Server Error)

`/clients/:client/history` (GET)
: desc.
  : Returns the history for a client.

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
