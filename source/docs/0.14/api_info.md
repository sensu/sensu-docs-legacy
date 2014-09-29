---
version: "0.14"
category: "API"
title: "API info"
---

# API Info

List the Sensu version and the transport and Redis connection
information (the same information that [/health](api_health) uses to
determine system health).

## /info {#info}

Example URL: `http://hostname:4567/info`

* `GET`: returns the API info

    - success: 200:

      ~~~ json
      {
          "sensu": {
              "version": "0.14.0"
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

- error: 500
