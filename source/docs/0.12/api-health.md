---
version: "0.12"
category: "API"
title: "Health"
alert: "Added in Sensu version 0.9.13+"
---

# Health API Endpoint

The health endpoint checks to see if the api can connect to redis and rabbitmq.  It takes parameters for minimum consumers and maximum messages and checks rabbitmq.

## `/health`

example url: `http://localhost:4567/health?consumers=2&messages=4`

* `GET`, returns the API info

  - Parameters
    
    - `consumers`
    
      - required

      - value: integer
    
      - description:  "The minimum number of consumers to be considered healthy."
    
    - `messages`
      
      - required

      - value: integer

      - description: "The maximum number of messages to be considered healthy."

  - success: 204 
      - No Content

  - error: 503
