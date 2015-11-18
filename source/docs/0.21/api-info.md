---
version: 0.21
category: "API Docs"
title: "Info API"
next:
  url: "enterprise-overview"
  text: "Enterprise Overview"
---

# Overview

List the Sensu version and the transport and Redis connection information. This is the same information that [/health](api-health) uses to determine system health.

# API Definition

`/info` (GET)
: desc
  : Returns information on the API.

: example url
  : http://hostname:4567/info

: response type
  : Hash

: response codes
  : - **Success**: 200 (OK)
    - **Error**: 500 (Internal Server Error)

: output
  : ~~~ json
    {
        "sensu": {
            "version": "0.16.0"
        },
        "transport": {
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
