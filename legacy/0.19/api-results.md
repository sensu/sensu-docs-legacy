---
version: 0.19
category: "API Docs"
title: "Results API"
next:
  url: "api-aggregates"
  text: "Aggregates API"
---

# Overview

List current check results.

# API Definition

`/results` (GET)
: desc
  : Returns a list of current check results for all clients.

: example url
  : http://hostname:4567/results

: response type
  : Array

: response codes
  : - **Success**: 200 (OK)
    - **Error**: 500 (Internal Server Error)

: output
  : ~~~ json
    [
        {
            "client": "i-424242",
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
                "duration": 0.005
            }
        }
    ]
    ~~~

`/results/:client` (GET)
: desc
  : Returns a list of current check results for a given client.

: example url
  : http://hostname:4567/results/i-424242

: response type
  : Array

: response codes
  : - **Success**: 200 (OK)
    - **Error**: 500 (Internal Server Error)

: output
  : ~~~ json
    [
        {
            "client": "i-424242",
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
                "duration": 0.005
            }
        }
    ]
    ~~~

`/results/:client/:check` (GET)
: desc
  : Returns a check result for a given client & check name.

: example url
  : http://hostname:4567/results/i-424242/chef_client_process

: response type
  : Hash

: response codes
  : - **Success**: 200 (OK)
    - **Missing**: 404 (Not Found)
    - **Error**: 500 (Internal Server Error)

: output
  : ~~~ json
    {
        "client": "i-424242",
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
            "duration": 0.005
        }
    }
    ~~~
