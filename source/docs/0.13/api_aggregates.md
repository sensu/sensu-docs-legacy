---
version: "0.13"
category: "API"
title: "API aggregates"
---

# API Aggregates

List and delete check aggregates.

This endpoint provides the information needed to monitor a collection
of machines running a service.

## `/aggregates` {#aggregates}

* `GET`: returns the list of aggregates

  - Parameters

    - `limit`

      - optional

      - value: integer

      - description: "The number of aggregates to return."

    - `offset`

      - optional

      - value: integer

      - depends: `limit`

      - description: "The number of aggregates to offset before returning items."

  - success: 200:

    ~~~ json
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

  - error: 500

## `/aggregates/:check` {#aggregates-check_name}

Example URL: `http://hostname:4567/aggregates/ntp_process`

* `GET`: returns the list of aggregates for a check

  - Parameters
    - `age`: optional, "The number of seconds old an aggregate must be to be listed."

  - success: 200:

    ~~~ json
    [
        1370738884,
        1370738854
    ]
    ~~~

  - missing: 404

  - error: 500

* `DELETE`: deletes all aggregates for a check

  - success: 204
    - No Content

  - missing: 404

  - error: 500

## `/aggregates/:check/:issued` {#aggregates-check-issued}

Example URL: `http://hostname:4567/aggregates/ntp_process/1370738854`

* `GET`: returns an aggregate

  - Parameters

    - `summarize`

      - value: `output`

      - optional

      - description: "Summarizes the output field in the event data. (summarize=ouput)"

      - example: `http://hostname:4567/aggregates/ntp_process/1370738854?summarize=output`

    - `results`

      - value: boolean

      - optional

      - description: "Return the raw result data"

      - example: `http://hostname:4567/aggregates/ntp_process/1370738854?results=true`

  - success: 200:

    ~~~ json
    {
        "ok": 2,
        "warning": 1,
        "critical": 0,
        "unknown": 1,
        "total": 4
    }
    ~~~

  - missing: 404

  - error: 500
