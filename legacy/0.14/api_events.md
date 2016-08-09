---
version: "0.14"
category: "API"
title: "API events"
---

# API Events

## `/events` {#events}

List and resolve current events. Every event occurrence has a unique ID (random UUID).

* `GET`: returns the list of current events

  - success: 200:

    ~~~ json
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

  - error: 500

## `/events/:client` {#events-client}

Example URL: `http://hostname:4567/events/i-424242`

* `GET`: returns the list of current events for a client

  - success: 200:

    ~~~ json
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

  - error: 500

## `/events/:client/:check` {#events-client-check}

Example URL: `http://hostname:4567/events/i-424242/chef_client_process`

* `GET`: returns an event

  - success: 200:

    ~~~ json
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

  - missing: 404

  - error: 500

* `DELETE`: resolves an event (delayed action)

  - success: 202

  - missing: 404

  - error: 500

## `/resolve` {#resolve}

* `POST`: resolves an event (delayed action)

  - payload:

    ~~~ json
    {
        "client": "i-424242",
        "check": "chef_client_process"
    }
    ~~~

  - success: 202

  - missing: 404

  - malformed: 400

  - error: 500
