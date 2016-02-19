---
version: 0.21
category: "API Docs"
title: "Events API"
next:
  url: "api-results"
  text: "Results API"
---

# Sensu Events API

List and resolve current events. Every event occurrence has a unique ID (random UUID).

## API Definition

`/events` (GET)
: desc
  : Returns the list of current events.

: example url
  : http://hostname:4567/events

: response type
  : Array

: response codes
  : - **Success**: 200 (OK)
    - **Error**: 500 (Internal Server Error)

: output
  : ~~~ json
    [
        {
            "id": "1ccfdf59-d9ab-447c-ac11-fd84072b905a",
            "client": {
                "name": "i-424242",
                "address": "127.0.0.1",
                "subscriptions": [
                    "webserver",
                    "production"
                ],
                "timestamp": 1389374650
            },
            "check": {
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
                "duration": 0.005,
                "history": [
                    "0",
                    "1",
                    "1"
                ]
            },
            "occurrences": 2,
            "action": "create"
        }
    ]
    ~~~

`/events/:client` (GET)
: desc
  : Returns the list of current events for a given client.

: example url
  : http://hostname:4567/events/i-424242

: response type
  : Array

: response codes
  : - **Success**: 200 (OK)
    - **Error**: 500 (Internal Server Error)

: output
  : ~~~ json
    [
        {
            "id": "1ccfdf59-d9ab-447c-ac11-fd84072b905a",
            "client": {
                "name": "i-424242",
                "address": "127.0.0.1",
                "subscriptions": [
                    "webserver",
                    "production"
                ],
                "timestamp": 1389374650
            },
            "check": {
                "name": "chef_client_process",
                "command": "check-procs.rb -p chef-client -W 1",
                "subscribers": [
                    "production"
                ],
                "interval": 60,
                "issued": 1389374667,
                "executed": 1389374667,
                "output": "WARNING Found 0 matching processes\n",
                "status": 1,
                "duration": 0.005,
                "history": [
                    "0",
                    "1",
                    "1"
                ]
            },
            "occurrences": 2,
            "action": "create"
        }
    ]
    ~~~

`/events/:client/:check` (GET)
: desc
  : Returns an event for a given client & check name.

: example url
  : http://hostname:4567/events/i-424242/chef_client_process

: response type
  : Hash

: response codes
  : - **Success**: 200 (OK)
    - **Missing**: 404 (Not Found)
    - **Error**: 500 (Internal Server Error)

: output
  : ~~~ json
    {
        "id": "1ccfdf59-d9ab-447c-ac11-fd84072b905a",
        "client": {
            "name": "i-424242",
            "address": "127.0.0.1",
            "subscriptions": [
                "webserver",
                "production"
            ],
            "timestamp": 1389374650
        },
        "check": {
            "name": "chef_client_process",
            "command": "check-procs.rb -p chef-client -W 1",
            "subscribers": [
                "production"
            ],
            "interval": 60,
            "issued": 1389374667,
            "executed": 1389374667,
            "output": "WARNING Found 0 matching processes\n",
            "status": 1,
            "duration": 0.005,
            "history": [
                "0",
                "1",
                "1"
            ]
        },
        "occurrences": 2,
        "action": "create"
    }
    ~~~

`/events/:client/:check` (DELETE)
: desc
  : Resolves an event for a given check on a given client. (delayed action)

: example url
  : http://hostname:4567/events/i-424242/chef_client_process

: response codes
  : - **Success**: 202 (Accepted)
    - **Missing**: 404 (Not Found)
    - **Error**: 500 (Internal Server Error)

`/resolve` (POST)
: desc.
  : Resolves an event. (delayed action)

: example url
  : http://hostname:4567/resolve

: payload
  : ~~~ json
    {
        "client": "i-424242",
        "check": "chef_client_process"
    }
    ~~~

: response codes
  : - **Success**: 202 (Accepted)
    - **Missing**: 404 (Not Found)
    - **Malformed**: 400 (Bad Request)
    - **Error**: 500 (Internal Server Error)
