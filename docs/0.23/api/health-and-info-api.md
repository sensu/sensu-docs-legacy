---
title: "Health & Info APIs"
version: 0.23
weight: 8
next:
  url: "configuration.html"
  text: "API Configuration"
---

# Sensu Health & Info APIs

## Reference documentation

- [How to obtain API status information](#how-to-obtain-api-status-information)
- [The `/health` API endpoint](#the-health-api-endpoint)
  - [`/health` (GET)](#health-get)
- [The `/info` API endpoint](#the-info-api-endpoint)
  - [`/info` (GET)](#info-get)

## How to obtain API status information

The Sensu API provides two distinct endpoints for obtaining API status
information: `/health` and `/info`. The Health API provides status information
about the health of the API's connections to the Sensu [data store][1] and
[transport][2]. The Info API provides a report on the status of the API,
including API version, the status of the API's connections to the Sensu data
store and transport, and the number of messages and consumers in various
transport queues.

## The `/health` API endpoint

### `/health` (GET)

The `/health` API provides HTTP GET access to test or verify the health of the
monitoring system. The Health API is provided for <abbr title="always monitor
your monitoring">monitoring Sensu</abbr> &mdash; it facilitates service checks
to ensure that a minimal number of [Sensu servers][3] are connected to the
transport (i.e. "transport consumers"), and/or to ensure that the transport
queue isn't growing (which would indicate that the Sensu servers aren't able to
keeping up with the volume of [keepalive messages][4] and [check results][5]
being produced).

_NOTE: the `/health` API obtains its information via the `/info` API._

_PRO TIP: the Health API [`messages` URL parameter][6] (e.g. `/health?messages=1000`)
can be used to monitor the number of messages queued on the [Sensu transport][2]
and then leveraged by other automation tools to trigger an "auto scaling" or
similar provisioning event, to automatically add one or more Sensu servers to a
Sensu installation._

#### EXAMPLE {#health-get-example}

In the following example, querying the `/health` API with the [`consumers`][6]
URL parameter will return an [HTTP response code][7] to indicate if the expected
number of consumers (i.e. [Sensu servers][3]) are processing check results. In
this example we are expecting at least two (2) consumers to be running at all
times (i.e. at least two Sensu servers processing check results). The [503
(Service Unavailable) HTTP response code][7] indicates that the requested number
of consumers are not registered.

~~~ shell
curl -s -i http://127.0.0.1:4567/health?consumers=2
HTTP/1.1 503 Service Unavailable
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Credentials: true
Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization
Connection: close
Server: thin
~~~

_NOTE: the ["503 (Service Unavailable)" HTTP response code][7] does **not** mean
that the API itself is unavailable, but rather, it is the equivalent of a
"false" response to the API query (i.e. if you want to know if there are "at
least two Sensu servers processing check results?", a 503 response code would
mean "no")._

_WARNING: transport "consumers" are a native concept in [pubsub technology][8]
(including **actual** message queues like [RabbitMQ][8]). Because the [Sensu
transport library][2] supports transports which are not actual message queues
(e.g. [Redis][10]), some transports do not support the Health API `consumers`
check, because they don't support the concept of "consumers"; i.e. this means
that `/health?consumers=1` will always fail (returning a 503 response code) for
Sensu installations using Redis as the transport, regardless of the number of
Sensu servers which may be registered and processing check results._

#### API Specification {#health-get-specification}

`/health` (GET)
: desc
  : Returns health information on transport & Redis connections.

: example url
  : http://hostname:4567/health

: parameters
  : - `consumers`:
      - **required**: true
      - **type**: Integer
      - **description**: The minimum number of transport consumers to be
        considered healthy
      - **notes**: not supported for Sensu installations using Redis as the
        transport
    - `messages`:
      - **required**: true
      - **type**: Integer
      - **description**: The maximum amount of transport queued messages to be
        considered healthy

: response type
  : [HTTP-header][11] only (no content)

: response codes
  : - **Success**: 204 (No Content)
    - **Error**: 503 (Service Unavailable)

: output
  : ~~~ shell
    HTTP/1.1 503 Service Unavailable
    Access-Control-Allow-Origin: *
    Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
    Access-Control-Allow-Credentials: true
    Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization
    Connection: close
    Server: thin
    ~~~

## The `/info` API endpoint

### `/info` (GET)

The `/info` API endpoint provides HTTP GET access to status information about
the monitoring system, including [data store][1] and [transport][2]
connectivity, and API version.

#### EXAMPLE {#info-get-example}

~~~ shell
$ curl -s http://127.0.0.1:4567/info | jq .
{
  "redis": {
    "connected": true
  },
  "transport": {
    "connected": true,
    "results": {
      "consumers": 0,
      "messages": 0
    },
    "keepalives": {
      "consumers": 0,
      "messages": 0
    }
  },
  "sensu": {
    "version": "0.23.0"
  }
}
~~~

#### API Specification {#info-get-specification}

`/info` (GET)
: desc
  : Returns information on the API.

: example url
  : http://hostname:4567/info

: response type
  : Hash

: response codes
  : - **Success**: 200 (OK)
    - **Error**: 500 (Internal Server Error)

: output
  : ~~~ json
    {
      "redis": {
        "connected": true
      },
      "transport": {
        "connected": true,
        "results": {
          "consumers": 0,
          "messages": 0
        },
        "keepalives": {
          "consumers": 0,
          "messages": 0
        }
      },
      "sensu": {
        "version": "0.23.0"
      }
    }
    ~~~

[1]:  ../reference/data-store.html
[2]:  ../reference/transport.html
[3]:  ../reference/server.html
[4]:  ../reference/clients.html#client-keepalives
[5]:  ../reference/checks.html#check-results
[6]:  #health-get-specification
[7]:  https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
[8]:  https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern
[9]:  https://www.rabbitmq.com/
[10]: http://redis.io/
[11]: https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html
