---
version: 0.18
category: "API Docs"
title: "Health API"
next:
  url: "api-info"
  text: "Info API"
---

# Overview

Check the status of the API's transport & Redis connections, and query the
transport's status. (consumer and message counts)

# API Definition

`/health` (GET)
: desc
  : Returns health information on transport & Redis connections.

: example url
  : http://hostname:4567/health

: parameters
  : - `consumers`:
      - **required**: true
      - **type**: Integer
      - **description**: The minimum number of transport consumers to be considered healthy.
    - `messages`:
      - **required**: true
      - **type**: Integer
      - **description**: The maximum ammount of transport queued messages to be considered healthy.

: response type
  : REPLACEME

: response codes
  : - **Success**: 204 (No Content)
    - **Error**: 503 (Service Unavailable)

: output
  : ~~~ json
    [ "REPLACEME" ]
    ~~~
