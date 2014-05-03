---
version: "0.12"
category: "API"
title: "Info"
---

# Info API Endpoint

The info endpoint will return the Sensu version along with rabbitmq and redis information.

## /info

example url: `http://localhost:4567/info`

* `GET`: returns the API info

    - success: 200:

        ~~~ json
        {
            "sensu": {
                "version": "0.9.12"
                },
            "rabbitmq": {
                "keepalives": {
                    "messages": 0,
                    "consumers": 1
                },
                "results": {
                    "messages": 0,
                    "consumers": 1
                },
                "connected": true
            },
            "redis": {
                "connected": true
            }
        }
        ~~~

- error: 500
