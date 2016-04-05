---
version: 0.22
category: "Reference Docs"
title: "Data Store"
next:
  url: "redis"
  text: "Redis Configuration"
---

# Sensu Data Store

Sensu services use a data store ([Redis](redis)) to persist monitoring data,
including the Sensu client registry, check results, check execution history, and
current event data. All Sensu Core server and API processes (i.e. `sensu-server`
and `sensu-api`), or the Sensu Enterprise process (i.e. `sensu-enterprise`)
require access to the same instance of the defined data store (i.e. a Redis
server or cluster).

_NOTE: unlike the [Sensu Transport](transport) &ndash; which is a Sensu library
that allows Sensu to be used with different transport backends (e.g. RabbitMQ or
Redis, etc) &ndash; the Sensu Data Store is not abstracted and/or extensible. At
this time, **Redis is the only data store supported by Sensu**. Having said
that, because this may change at some point in the future, we are beginning to
use the term "data store" in the Sensu documentation as an abstraction for the
functions currently provided by Redis._
