---
layout: default
title: info
description: The Sensu API
version: 0.9
---

<div class="page-header">
  <h1>Info API Endpoint<small></small></h1>
</div>

The info endpoint will return the Sensu version along with rabbitmq and redis information.

## /info

example url: `http://localhost:4567/info`

* `GET`: returns the API info

    - success: 200:

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

    - error: 500
