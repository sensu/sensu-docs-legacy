---
version: 0.23
category: "API Docs"
title: "Sensu API Overview"
next:
  url: "api-clients"
  text: "Clients API"
---

# Sensu API

The Sensu API provides access to monitoring data collected by Sensu, such as
a [client registry][1], [check results][2], and [event data][3]. The API can be
used to request adhoc check executions, and resolve events, among other things.

## RESTful JSON API

The Sensu API is [JSON][4]-based [RESTful API][5]. Familiarity with (or
willingness to Google) industry standard RESTful API behaviors &ndash; including
[HTTP response codes][6] &ndash; are strongly recommended.

## Reference Documentation

- [Clients API](api-clients)
- [Checks API](api-checks)
- [Events API](api-events)
- [Results API](api-results)
- [Aggregates API](api-aggregates)
- [Stashes API](api-stashes)
- [Health & Info API](api-health-and-info)
- [API configuration](api-configuration)

[1]:  clients#registration-and-registry
[2]:  checks#check-results
[3]:  events#event-data
[4]:  http://www.json.org/
[5]:  https://en.wikipedia.org/wiki/Representational_state_transfer
[6]:  https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
