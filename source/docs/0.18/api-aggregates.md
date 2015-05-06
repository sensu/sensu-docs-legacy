---
version: 0.18
category: "API Docs"
title: "Aggregates API"
next:
  url: "api-stashes"
  text: "Stashes API"
---

# Overview

List and delete check aggregates.

This endpoint provides the information needed to monitor a collection of
machines running a service.

# API Definition

`/aggregates` (GET)
: desc
  : Returns the list of aggregates.

: example url
  : http://hostname:4567/aggregates

: parameters
  : - `limit`:
      - **required**: false
      - **type**: Integer
      - **description**: The number of aggregates to return.
    - `offset`:
      - **required**: false
      - **type**: Integer
      - **depends**: `limit`
      - **description**: The number of aggregates to offset before returning items.

: response type
  : Array

: response codes
  : - **Success**: 200 (OK)
    - **Error**: 500 (Internal Server Error)

: output
  : ~~~ json
    [
        {
            "check": "sshd_process",
            "issued": [
                1370738883,
                1370738853
            ]
        },
        {
            "check": "ntp_process",
            "issued": [
                1370738884,
                1370738854
            ]
        }
    ]
    ~~~

`/aggregates/:check` (GET)
: desc
  : Returns the list of aggregates for a given check.

: example url
  : http://hostname:4567/aggregates/ntp_process

: parameters
  : - `age`:
      - **required**: false
      - **type**: Integer
      - **description**: The number of seconds old an aggregate must be to be listed.

: response type
  : Array

: response codes
  : - **Success**: 200 (OK)
    - **Missing**: 404 (Not Found)
    - **Error**: 500 (Internal Server Error)

: output
  : ~~~ json
    [
        1370738884,
        1370738854
    ]
    ~~~

`/aggregates/:check` (DELETE)
: desc
  : Deletes all aggregates for a check.

: example url
  : http://hostname:4567/aggregates/ntp_process

: response codes
  : - **Success**: 204 (No Content)
    - **Missing**: 404 (Not Found)
    - **Error**: 500 (Internal Server Error)

`/aggregates/:check/:issued` (GET)
: desc
  : Returns an aggregate.

: example URL
  : http://hostname:4567/aggregates/ntp_process/1370738854

: parameters
  : - `summarize`:
      - **required**: false
      - **type**: String
      - **description**: Summarizes the output field in the event data. (summarize=output)
    - `results`:
      - **required**: false
      - **type**: Boolean
      - **description**: Return the raw result data.

: response codes
  : - **Success**: 200 (OK)
    - **Missing**: 404 (Not Found)
    - **Error**: 500 (Internal Server Error)

: output
  : ~~~ json
    {
        "ok": 2,
        "warning": 1,
        "critical": 0,
        "unknown": 1,
        "total": 4
    }
    ~~~
