---
title: "Overview"
version: 0.26
weight: 1
next:
  url: "clients-api.html"
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

## Reference documentation

- [Clients API](clients-api.html)
- [Checks API](checks-api.html)
- [Results API](results-api.html)
- [Aggregates API](aggregates-api.html)
- [Events API](events-api.html)
- [Stashes API](stashes-api.html)
- [Health & Info API](health-and-info-api.html)
- [API configuration](configuration.html)

[1]:  ../reference/clients.html#registration-and-registry
[2]:  ../reference/checks.html#check-results
[3]:  ../reference/events.html#event-data
[4]:  http://www.json.org/
[5]:  https://en.wikipedia.org/wiki/Representational_state_transfer
[6]:  https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
