---
version: "0.12"
category: "Configuration"
title: "Event Data"
---

# Sensu event data {#sensu-event-data}

Event data consists of client and check information, and some metadata.

Event data is JSON encoded, making it  language-independent and fairly human readable.

~~~ json
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
~~~
# Sensu client event data {#sensu-client-event-data}

The Sensu client listens on udp and tcp port 3030.  Metric and check results can be submitted to this port unsolicited and will enter the Sensu pipeline.

The content of the result is JSON encoded and contains any value that would occur inside the "check" block above.  The minimum required fields are "name" and "output". A Handler is highly desirable. "Status" defaults to 0.

~~~ json
{
    "name": "metric_cpu_load",
    "type": "metric",
    "handler": "graphite",
    "output": "ip-10-10-10-10.cpu.load.1m .5 1406129070\nip-10-10-10-10.cpu.load.1m .5 1406129070\nip-10-10-10-10.cpu.load.1m .5 1406129070"
}
~~~
