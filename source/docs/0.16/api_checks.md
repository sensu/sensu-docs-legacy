---
version: "0.16"
category: "API"
title: "API checks"
---

# API Checks

List locally defined checks and request executions.

## `/checks` {#checks}

* `GET`: returns the list of checks

  - success: 200:

    ~~~ json
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

  - error: 500

## `/checks/:check` {#checks-check}

Example URL: `http://hostname:4567/checks/chef_client_process`

* `GET`: returns a check

  - success: 200:

    ~~~ json
    {
        "name": "chef_client_process",
        "command": "check-procs.rb -p /usr/bin/chef-client -W 1 -w 2 -c 3",
        "subscribers": [
            "production"
        ],
        "interval": 60
    }
    ~~~

  - missing: 404

  - error: 500

## `/request` {#request}

* `POST`: issues a check execution request

  - payload:

    ~~~ json
    {
        "check": "chef_client_process",
        "subscribers": [
            "production"
        ]
    }
    ~~~

  - success: 202

  - malformed: 400

  - error: 500
