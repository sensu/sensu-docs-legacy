---
version: 0.17
category: "API Docs"
title: "Checks API"
next:
  url: "api-handlers"
  text: "Handlers API"
---

# Overview

List locally defined checks and request executions.

# API Definition

`/checks` (GET)
: desc.
  : Returns the list of checks.

: response type
  : Array

: response codes
  : - **Success**: 200 (OK)
    - **Error**: 500 (Internal Server Error)

: output
  : ~~~ json
    [
        {
            "name": "chef_client_process",
            "command": "check-procs.rb -p /usr/bin/chef-client -W 1 -w 2 -c 3",
            "subscribers": [
                "production"
            ],
            "interval": 60
        },
        {
            "name": "website",
            "command": "check-http.rb -h localhost -p /health -P 80 -q Passed -t 30",
            "subscribers": [
                "webserver"
            ],
            "interval": 30
        }
    ]
    ~~~

`/checks/:check` (GET)
: desc.
  : Returns a check.

: response type
  : Hash

: response codes
  : - **Success**: 200 (OK)
    - **Missing**: 404 (Not Found)
    - **Error**: 500 (Internal Server Error)

: output
  : ~~~ json
    {
        "name": "chef_client_process",
        "command": "check-procs.rb -p /usr/bin/chef-client -W 1 -w 2 -c 3",
        "subscribers": [
            "production"
        ],
        "interval": 60
    }
    ~~~

`/request` (POST)
: desc.
  : Issues a check execution request.

: payload
  : ~~~ json
    {
        "check": "chef_client_process",
        "subscribers": [
            "production"
        ]
    }
    ~~~

: response codes
  : - **Success**: 202 (Accepted)
    - **Missing**: 404 (Not Found)
    - **Error**: 500 (Internal Server Error)
