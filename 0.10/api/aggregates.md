---
layout: default
title: aggregate
description: The Sensu API
version: '0.10'
---

<div class="page-header">
  <h1>Aggregates API Endpoints<small></small></h1>
</div>

The aggregate endpoints allows you to list and delete aggregate checks.

## `/aggregates`

  example url - http://localhost:4567/aggregates

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

              [
                {
                  "check": "sshd_process",
                  "issued": [1370738883,1370738853,1370738823,1370738793,1370738763,1370738733,1370738703,1370738673]
                },
                {
                  "check": "ntp_process",
                  "issued": [1370738883,1370738853,1370738823,1370738793,1370738763,1370738733,1370738703,1370738673]
                }
              ]

  - error: 500

## `/aggregates/:check_name`

example url - http://localhost:4567/aggregates/check_something

* `GET`: returns the list of aggregates

  - Parameters
    - `age`: optional, "The number of seconds from now to get aggregates."

  - success: 200:

              [
                1370738973,1370738943,1370738913,1370738883,1370738853,1370738823,1370738793,1370738763,1370738733
              ]

  - missing: 404

  - error: 500

* `DELETE`: returns the list of aggregates

  - success: 204
    - No Content

  - missing: 404

  - error: 500

## `/aggregates/:check_name/:check_issued`

example url - http://localhost:4567/aggregates/client_1/check_1

* `GET`: returns the list of aggregates

  - Parameters
    
    - `summarize`
    
      - value: `output`
    
      - optional

      - description: "Summarizes the output field in the event data. (summarize=ouput)"

      - example:  http://localhost:4567/aggregates/client_1/check_1?summarize=output
    
    - `results`

      - value: boolean

      - optional

      - description: "Adds the event results data to the output"

      - example:  http://localhost:4567/aggregates/client_1/check_1?results=true

  - success: 200:

            {
              "ok": 0,
              "warning": 0,
              "critical": 0,
              "unknown": 1,
              "total": 1
            }

  - missing: 404

  - error: 500
