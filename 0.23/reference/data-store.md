---
title: "Data Store"
version: 0.23
weight: 12
---

# Sensu Data Store

## Reference documentation

- [What is the Sensu data store?](#what-is-the-sensu-data-store)

## What is the Sensu data store?

Sensu services use a data store ([Redis][1]) to persist monitoring data,
including the Sensu client registry, check results, check execution history, and
current event data. All Sensu Core server and API processes (i.e. `sensu-server`
and `sensu-api`), or the Sensu Enterprise process (i.e. `sensu-enterprise`)
require access to the same instance of the defined data store (i.e. a Redis
server or cluster).

_NOTE: unlike the [Sensu Transport][2] &ndash; which is a Sensu library
that allows Sensu to be used with different transport backends (e.g. RabbitMQ or
Redis, etc) &ndash; the Sensu Data Store is not abstracted and/or extensible. At
this time, **Redis is the only data store supported by Sensu**. Having said
that, because this may change at some point in the future, we are beginning to
use the term "data store" in the Sensu documentation as an abstraction for the
functions currently provided by Redis._


[1]:  redis.html
[2]:  transport.html
