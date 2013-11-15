---
version: "0.11"
category: "API"
title: "Clients"
---

# Client API Endpoints

The client endpoints allows you to list, delete and get the histroy of clients.

## `/clients`

example url - `http://localhost:4567/clients`

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

      ``` json
      [
        {
          "name": "client_1",
          "address": "192.168.0.2",
          "subscriptions": [
            "chef-client",
            "sensu-server"
          ],
          "timestamp": 1324674972
        },
        {
          "name": "client_2",
          "address": "192.168.0.3",
          "subscriptions": [
            "chef-client",
            "webserver",
            "memcached"
          ],
          "timestamp": 1324674956
        }
      ]
      ```

  - error: 500

## `/clients/:name`

example url - http://localhost:4567/clients/client_2

* `GET`: returns a client

  - success: 200:

      ``` json
      {
        "name": "client_2",
        "address": "192.168.0.3",
        "subscriptions": [
          "chef-client",
          "webserver",
          "memcached"
        ],
        "timestamp": 1324674956
      }
      ```

  - missing: 404

  - error: 500

* `DELETE`: removes a client, resolving its current events (delayed action)

  - success: 202

  - missing: 404

  - error: 500

## `/clients/:name/history`

example url - http://localhost:4567/clients/client_2/history

* `GET`: returns the client history

  - success: 200:

      ``` json
      [
        { 
          "check": "redis_process",
          "history": [127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127],
          "last_execution": 1370725352,
          "last_status": 127
        }, 
        {
          "check": "redis_metrics",
          "history": [127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127],
          "last_execution": 1370725352,
          "last_status": 127
        },
        { 
          "check": "keepalive",
          "history": [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
          "last_execution": 1370725351,
          "last_status": 0
        }
      ]
      ```

  - error: 500

