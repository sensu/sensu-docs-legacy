---
layout: default
title: health
description: The Sensu API
version: '0.10'
---

<div class="page-header">
  <h1>Health API Endpoint<small></small></h1>
</div>

The health endpoint checks to see if the api can connect to redis and rabbitmq.  It takes parameters for minimum consumers and maximum messages and checks rabbitmq.

<div class="alert alert-info">
   Added in Sensu Version: 0.9.13+
</div>

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
