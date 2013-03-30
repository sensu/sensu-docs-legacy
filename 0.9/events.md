---
layout: default
title: Events
description: Sensu events
version: 0.9
---

# Sensu event data

## What does event data look like?
Event data consists of client and check information, and some metadata.

Event data is JSON encoded, making it  language-independent and fairly human readable.

### Example

{% highlight json %}
    {
      "client":{
        "name": "host01",
        "address": "10.2.1.11",
        "subscriptions": [
          "all",
          "frontend",
          "proxy"
        ],
        "timestamp": 1326390159
      },
      "check":{
        "name": "frontend_http_check",
        "issued": 1326390169,
        "output": "HTTP CRITICAL: HTTP/1.1 503 Service Temporarily Unavailable",
        "status": 2,
        "command": "check_http -I 127.0.0.1 -u http://web.example.com/healthcheck.html -R 'pageok'",
        "subscribers":[
          "frontend"
        ],
        "interval": 60,
        "handler": "campfire",
        "history": [
          "0",
          "2"
        ],
        "flapping": false
      },
      "occurrences": 1,
      "action": "create"
    }
{% endhighlight %}
