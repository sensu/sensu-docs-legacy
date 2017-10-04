---
title: "Silenced API"
version: 1.0
weight: 7
next:
  url: ".html"
  text: ""
---

# Sensu Silenced API

## Reference documentation

- [The `/silenced` API endpoints](#the-silenced-api-endpoints)
  - [`/silenced` (GET)](#silenced-get)
  - [`/silenced` (POST)](#silenced-post)
  - [`/silenced/ids/:id` (GET)](#silencedidsid-get)
  - [`/silenced/clear` (POST)](#silenced-clear-post)
  - [`/silenced/subscriptions/:subscription` (GET)](#silenced-subscriptions-get)
  - [`/silenced/checks/:check` (GET)](#silenced-checks-get)

## The `/silenced` API endpoints

The Silence API provides endpoint HTTP POST and GET access to create, query and
clear (delete) a silence entry via the Sensu API.

### `/silenced` (GET)

#### Example: Querying for all silence entries

~~~ shell
$ curl -s -X GET http://localhost:4567/silenced |jq .
[
  {
    "expire": 3530,
    "expire_on_resolve": false,
    "creator": null,
    "reason": null,
    "check": "check_haproxy",
    "subscription": "load-balancer",
    "id": "load-balancer:check_haproxy"
  },
  {
    "expire": -1,
    "expire_on_resolve": true,
    "creator": "sysop@example.com",
    "reason": "we ran out of time",
    "check": "check_ntpd",
    "subscription": "all",
    "id": "all:check_ntpd"
  }
]
~~~

#### API specification {#silenced-get-specification}

`/silenced` (GET)
: desc
  : Returns a list of silence entries.
: example url
  : http://hostname:4567/silenced
: parameters
  : - `limit`:
      - **required**: false
      - **type**: Integer
      - **description**: The number of silence entries to return.
    - `offset`:
      - **required**: false
      - **type**: Integer
      - **depends**: `limit`
      - **description**: The number of silence entries to offset before
      returning items.
: response type: Array
: response codes
  : - **Success**: 200 (OK)
    - **Error**: 500 (Internal Server Error)
: output
  : ~~~ json
    [
      {
        "expire": 3530,
        "expire_on_resolve": false,
        "creator": null,
        "reason": null,
        "check": "check_haproxy",
        "subscription": "load-balancer",
        "id": "load-balancer:check_haproxy"
      },
      {
        "expire": -1,
        "expire_on_resolve": true,
        "creator": "sysop@example.com",
        "reason": "we ran out of time",
        "check": "check_ntpd",
        "subscription": "all",
        "id": "all:check_ntpd"
      }
    ]
    ~~~

### `/silenced` (POST)

#### Example: Creating a silence entry {#silence-post-examples}

The following example demonstrates a `/silenced` query, which creates a
silence entry for the check "check_haproxy" on clients with the
"load-balancer" subscription, with an expiration of 3600 seconds:

~~~ shell
$ curl -s -i -X POST \
-H 'Content-Type: application/json' \
-d '{"subscription": "load-balancer", "check": "check_haproxy", "expire": 3600 }' \
http://localhost:4567/silenced

HTTP/1.1 201 Created
Access-Control-Allow-Credentials: true
Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Origin: *
Connection: close
Content-length: 0

$ curl -s -X GET http://localhost:4567/silenced | jq .
[
  {
    "expire": 3594,
    "expire_on_resolve": false,
    "creator": null,
    "reason": null,
    "check": "check_haproxy",
    "subscription": "load-balancer",
    "id": "load-balancer:check_haproxy"
  }
]
~~~

#### API specification {#silenced-post-specification}

`/silenced` (POST)
: desc
  : Create a silence entry.
: example URL
  : http://hostname:4567/silenced
: payload
  : ~~~ json
    {
      "subscription": "load-balancer",
      "expire": 3600,
      "reason": "load-balancer maintenance window",
      "creator": "sysop@example.com"
    }
    ~~~
: payload parameters
  : - `check`
     - **required**: true, unless `subscription` is specified
     - **type**: String
     - **description**: Specifies the check which the silence entry applies to.
     - **example**: "check_haproxy"
  : - `creator`
     - **required**: false
     - **type**: String
     - **description**: Specifies the entity responsible for this entry.
     - **example**: "you@yourdomain.com" or "Your Name Here"
  : - `expire`
      - **required**: false
      - **type**: Integer
      - **description**: If specified, the silence entry will be
      automatically cleared after this number of seconds.
      - **example**: 1800
  : - `expire_on_resolve`
      - **required**: false
      - **type**: Boolean
      - **description**: If specified as true, the silence entry will be
      automatically cleared once the condition it is silencing is resolved.
      - **example**: true
  : - `reason`
      - **required**: false
      - **type**: String
      - **description**: If specified, this free-form string is used to provide context
      or rationale for the reason this silence entry was created.
      - **example**: "pre-arranged maintenance window"
  : - `subscription`
      - **required**: true, unless `check` is specified
      - **type:** String
      - **description**: Specifies the subscription which the silence entry applies to.
: response codes
  : - **Success**: 201 (Created)
    - **Malformed**: 400 (Bad Request)
    - **Error**: 500 (Internal Server Error)

### `/silenced/ids/:id` (GET)

#### Example: Querying for a specific silence entry

~~~ shell
$ curl -s -X GET http://localhost:4567/silenced/ids/load-balancer:check_haproxy |jq .
{
  "id": "load-balancer:check_haproxy",
  "subscription": "load-balancer",
  "check": "check_haproxy",
  "reason": null,
  "creator": null,
  "expire_on_resolve": false,
  "expire": 3529
}
~~~

#### API specification {#silencedids-get-specification}

`/silenced/ids/:id` (GET)
: desc
  : Returns a specific silenced override by it's ID.
: example url
  : http://hostname:4567/silenced/webserver:check_nginx
: response type: Hash
: response codes
  : - **Success**: 200 (OK)
    - **Missing**: 404 (Not Found)
    - **Error**: 500 (Internal Server Error)
: output
  : ~~~ json
    {
      "id": "webserver:check_nginx",
      "subscription": "webserver",
      "check": "check_nginx",
      "reason": null,
      "creator": null,
      "expire_on_resolve": false,
      "expire": -1
    }
    ~~~

### `/silenced/clear` (POST)

#### Example: Clearing a silence entry

A silence entry can be cleared (deleted) by its ID:

~~~ shell
$ curl -s -X GET http://localhost:4567/silenced | jq .
[
  {
    "expire": 3594,
    "expire_on_resolve": false,
    "creator": null,
    "reason": null,
    "check": "check_haproxy",
    "subscription": "load-balancer",
    "id": "load-balancer:check_haproxy"
  }
]

$ curl -s -i -X POST \
-H 'Content-Type: application/json' \
-d '{ "id": "load-balancer:check_haproxy" }' \
http://localhost:4567/silenced/clear

HTTP/1.1 204 No Content
Access-Control-Allow-Credentials: true
Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Origin: *
Connection: close
Content-length: 0

$ curl -s -X GET http://localhost:4567/silenced | jq .
[]
~~~

A silence entry can also be cleared by specifying the intersection of
subscription and/or handler to which the entry applies:

~~~ shell
$ curl -s -X GET http://localhost:4567/silenced | jq .
[
  {
    "expire": null,
    "expire_on_resolve": false,
    "creator": null,
    "reason": null,
    "check": "check_ntpd",
    "subscription": "all",
    "id": "all:check_ntpd"
  }
]

$ curl -s -i -X POST \
-H 'Content-Type: application/json' \
-d '{ "subscription": "all", "check": "check_ntpd" }' \
http://localhost:4567/silenced/clear

HTTP/1.1 204 No Content
Access-Control-Allow-Credentials: true
Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Origin: *
Connection: close
Content-length: 0

$ curl -s -X GET http://localhost:4567/silenced | jq .
[]
~~~

#### API specification {#silenced-clear-post-specification}

`/silenced/clear` (POST)
: desc
  : Clear a silence entry.
: example URL
  : http://hostname:4567/silenced/clear
: payload
  : ~~~ json
    {
      "id": "load-balancer:ha_proxy"
    }
    ~~~
: payload parameters
  : - `check`
      - **required**: true, unless `subscription` or `id` is specified
      - **type**: String
      - **description**: Specifies the name of the check for which the silence
      entry should be cleared.
      - **example**: "check_haproxy"
  : - `subscription`:
      - **required**: true, unless `client` is specified
      - **type:** String
      - **description**: Specifies the name of the subscription for which the silence
     entry should be cleared.
  : - `id`:
      - **required**: true, unless `client` or is specified
      - **type:** String
      - **description**: Specifies the id (intersection of subscription and
      check) of the subscription for which the silence entry should be cleared.
: response codes
  : - **Success**: 204 (No Content)
    - **Malformed**: 400 (Bad Request)
    - **Error**: 500 (Internal Server Error)

### `/silenced/subscriptions/:subscription` (GET)

#### Example: Querying for silence entries via subscription name

~~~ shell
$ curl -s -X GET http://localhost:4567/silenced/subscriptions/load-balancer | jq .
[
  {
    "expire": 3596,
    "expire_on_resolve": false,
    "creator": null,
    "reason": null,
    "check": "check_ntpd",
    "subscription": "load-balancer",
    "id": "load-balancer:check_ntpd"
  }
]
~~~

#### API specification {#silenced-subscriptions-get-specification}

`/silenced/subscriptions/:subscription` (GET)
: desc
  : Returns a list of silence entries matching the specified subscription name.
: example url
  : http://hostname:4567/silenced/subscriptions/load-balancer

: response type
  : Array

: parameters
  : - `limit`
      - **required**: false
      - **type**: Integer
      - **description**: The number of clients to return.
      - **example**: `http://hostname:4567/subscriptions/load-balancer?limit=100`
    - `offset`
      - **required**: false
      - **type**: Integer
      - **depends**: `limit`
      - **description**: The number of clients to offset before returning items.
      - **example**: `http://hostname:4567/subscriptions/load-balancer?limit=100&offset=100`

: response codes
  : - **Success**: 200 (OK)
    - **Error**: 500 (Internal Server Error)

### `/silenced/checks/:check` (GET)

#### Example: Querying for silence entries via check name

~~~ shell
$ curl -s -X GET http://localhost:4567/silenced/checks/check_ntpd | jq .
[
  {
    "expire": -1,
    "expire_on_resolve": false,
    "creator": "sysop@example.com",
    "reason": "we ran out of time",
    "check": "check_ntpd",
    "subscription": "webserver",
    "id": "webserver:check_ntpd"
  },
  {
    "expire": -1,
    "expire_on_resolve": false,
    "creator": "sysop@example.com",
    "reason": "we ran out of time",
    "check": "check_ntpd",
    "subscription": "load-balancer",
    "id": "load-balancer:check_ntpd"
  }
]
~~~

#### API specification {#silenced-checks-get-specification}

`/silenced/checks/:check` (GET)
: desc
  : Returns a list of silence entries matching the specified check name.

: example url
  : http://hostname:4567/silenced/checks/check_ntpd

: response type
  : Array

: parameters
  : - `limit`
      - **required**: false
      - **type**: Integer
      - **description**: The number of silence entries to return.
      - **example**: `http://hostname:4567/silenced/checks/check_ntpd?limit=100`
    - `offset`
      - **required**: false
      - **type**: Integer
      - **depends**: `limit`
      - **description**: The number of clients to offset before returning items.
      - **example**: `http://hostname:4567/silenced/checks/check_ntpd?limit=100&offset=100`

: response codes
  : - **Success**: 200 (OK)
    - **Error**: 500 (Internal Server Error)
