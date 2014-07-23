---
version: "0.13"
category: "API"
title: "Health"
---

# API Health

Check the status of the API's RabbitMQ & Redis connections, and query
RabbitMQ's status (consumer and message counts).

## `/health` {#health}

Example URL: `http://hostname:4567/health?consumers=2&messages=100`

* `GET`, returns the API info

  - Parameters

    - `consumers`

      - required

      - value: integer

      - description:  "The minimum number of RabbitMQ queue consumers to be considered healthy."

    - `messages`

      - required

      - value: integer

      - description: "The maximum number of RabbitMQ queue messages to be considered healthy."

  - success: 204
      - No Content

  - error: 503
