---
title: "Stashes API"
version: 0.24
weight: 7
next:
  url: "health-and-info-api.html"
  text: "Health & Info API"
---

# Sensu Stashes API

## Reference documentation

- [The `/stashes` API endpoints](#the-stashes-api-endpoints)
  - [`/stashes` (GET)](#stashes-get)
  - [`/stashes` (POST)](#stashes-post)
- [The `/stashes/:path` API endpoints](#the-stashespath-api-endpoints)
  - [`/stashes/:path` (GET)](#stashespath-get)
  - [`/stashes/:path` (POST)](#stashespath-post)
  - [`/stashes/:path` (DELETE)](#stashespath-delete)

## The `/stashes` API endpoints

The `/stashes` API endpoint provides HTTP GET and HTTP POST access to [Sensu
stash data][3] via the [Sensu key/value store][4].

### `/stashes` (GET)

#### EXAMPLES {#stashes-get-examples}

The following example demonstrates a `/stashes` query, which results in a JSON
Array of JSON Hashes containing [stash data][3].

~~~
$ curl -s http://localhost:4567/stashes | jq .
[
  {
    "path": "silence/i-424242/chef_client_process",
    "content": {
      "timestamp": 1383441836
    },
    "expire": 3600
  },
  {
    "path": "application/storefront",
    "content": {
      "timestamp": 1381350802,
      "endpoints": [
        "https://hostname/store"
      ]
    },
    "expire": -1
  }
]
~~~

#### API specification {#stashes-get-specification}  

`/stashes` (GET)
: desc
  : Returns a list of stashes.
: example url
  : http://hostname:4567/stashes
: parameters
  : - `limit`:
      - **required**: false
      - **type**: Integer
      - **description**: The number of stashes to return.
    - `offset`:
      - **required**: false
      - **type**: Integer
      - **depends**: `limit`
      - **description**: The number of stashes to offset before returning items.
: response type
  : Array
: response codes
  : - **Success**: 200 (OK)
    - **Error**: 500 (Internal Server Error)
: output
  : ~~~ json
    [
      {
        "path": "silence/i-424242/chef_client_process",
        "content": {
          "timestamp": 1383441836
        },
        "expire": 3600
      },
      {
        "path": "application/storefront",
        "content": {
          "timestamp": 1381350802,
          "endpoints": [
            "https://hostname/store"
          ]
        },
        "expire": -1
      }
    ]
    ~~~

### `/stashes` (POST)

#### EXAMPLES {#stashes-post-examples}

The following example demonstrates submitting an HTTP POST containing a JSON
document payload to the `/stashes` API, resulting in a [201 (Created) HTTP
response code][5] and a payload containing a JSON Hash confirming the stash
`path` (i.e. the "key" where the stash can be accessed).

~~~ shell
curl -s -i -X POST \
-H 'Content-Type: application/json' \
-d '{"path": "example/stash/path", "content": { "foo": "bar" }}' \
http://localhost:4567/stashes

HTTP/1.1 201 Created
Content-Type: application/json
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Credentials: true
Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization
Content-Length: 29
Connection: keep-alive
Server: thin

{"path":"example/stash/path"}
~~~

#### API specification {#stashes-post-specification}

`/stashes` (POST)
: desc
  : Create a stash. (JSON document)
: example URL
  : http://hostname:4567/stashes
: payload
  : ~~~ json
    {
      "path": "example/stash",
      "content": {
        "message": "example"
      },
      "expire": -1
    }
    ~~~
: response codes
  : - **Success**: 201 (Created)
    - **Malformed**: 400 (Bad Request)
    - **Error**: 500 (Internal Server Error)

## The `/stashes/:path` API endpoints

The `/stashes/:path` API endpoint provides HTTP GET, HTTP POST, and HTTP DELETE
access to [Sensu stash data][3] for specified `:path`s (i.e. "keys") via the
[Sensu key/value store][4].

### `/stashes/:path` (GET)

#### EXAMPLES {#stashespath-get-examples}

The following example demonstrates a `/stashes/:path` API query for a stash
located at the `my/example/path` `:path`, resulting in a JSON Hash of [stash
`content` data][8].

~~~
$ curl -s http://localhost:4567/stashes/my/example/stash | jq .
{
  "message": "hello world"
}
~~~

_NOTE: the `/stashes/:path` API endpoint provides [direct access to stash
`content` data][7], so only [stash `content` attributes][8] are provided for
`/stashes/:path` API queries (not [complete stash definitions][9])._

#### API specification {#stashespath-get-specification}

`/stashes/:path` (GET)
: desc
  : Get a stash. (JSON document)
: example URL
  : http://hostname:4567/stashes/example/stash
: response type
  : Hash
: response codes
  : - **Success**: 200 (OK)
    - **Missing**: 404 (Not Found)
    - **Error**: 500 (Internal Server Error)
: output
  : ~~~
    {
      "message": "hello world"
    }
    ~~~

    _NOTE: the `/stashes/:path` API endpoint provides [direct access to stash
    `content` data][7], so only [stash `content` attributes][8] are provided for
    `/stashes/:path` API queries (not [complete stash definitions][9])._

### `/stashes/:path` (POST)

#### EXAMPLES {#stashespath-post-examples}

The following example demonstrates submitting an HTTP POST to the
`/stashes/:path` API with a `:path` called `my/example/path`, resulting in a
[201 (Created) HTTP response code][5] (i.e. `HTTP/1.1 201 Created`), and a
payload containing a JSON Hash confirming the stash `path` (i.e. the "key" where
the stash can be accessed).

~~~ shell
$ curl -s -i -X POST \
-H 'Content-Type: application/json' \
-d '{"message": "hello world"}' \
http://localhost:4567/stashes/my/example/path

HTTP/1.1 201 Created
Content-Type: application/json
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Credentials: true
Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization
Content-Length: 26
Connection: keep-alive
Server: thin

{"path":"my/example/path"}
~~~

#### API specification {#stashespath-post-specification}

`/stashes/:path` (POST)
: desc
  : Create a stash. (JSON document)
: example URL
  : http://hostname:4567/stashes/example/stash
: payload
  : ~~~ json
    {
      "message": "example"
    }
    ~~~
    _NOTE: the `/stashes/:path` API endpoint provides [direct access to stash
    `content` data][7]; as a result, it expects [stash `content` attributes][8]
    only (i.e. not a complete [stash definition][9])._
: response type
  : Hash
: response codes
  : - **Success**: 201 (Created)
    - **Malformed**: 400 (Bad Request)
    - **Error**: 500 (Internal Server Error)
: output
  : ~~~
    HTTP/1.1 201 Created
    Content-Type: application/json
    Access-Control-Allow-Origin: *
    Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
    Access-Control-Allow-Credentials: true
    Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization
    Content-Length: 26
    Connection: keep-alive
    Server: thin

    {"path":"my/example/path"}
    ~~~

### `/stashes/:path` (DELETE)

#### EXAMPLES {#stashespath-delete-examples}

The following example demonstrates submitting an HTTP DELETE to the
`/stashes/:path` API with a `:path` called `my/example/path`, resulting in a
[204 (No Response) HTTP response code][5] (i.e. `HTTP/1.1 204 No Response`).

~~~ shell
$ curl -s -i -X DELETE http://localhost:4567/stashes/my/example/path                                                                                                                                                                                        
HTTP/1.1 204 No Content
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Credentials: true
Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization
Connection: close
Server: thin
~~~

#### API specification {#stashespath-delete-specification}

`/stashes/:path` (DELETE)
: desc
  : Delete a stash. (JSON document)
: example URL
  : http://hostname:4567/stashes/example/stash
: response type
  : [HTTP-header][10] only (no output)
: response codes
  : - **Success**: 204 (No Response)
    - **Missing**: 404 (Not Found)
    - **Error**: 500 (Internal Server Error)
: output
  : ~~~
    HTTP/1.1 204 No Content
    Access-Control-Allow-Origin: *
    Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
    Access-Control-Allow-Credentials: true
    Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization
    Connection: close
    Server: thin
    ~~~

[1]:  https://en.wikipedia.org/wiki/Key-value_database
[2]:  ../reference/events.html
[3]:  ../reference/stashes.html#what-is-a-sensu-stash
[4]:  ../reference/stashes.html#the-sensu-keyvalue-store
[5]:  https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
[6]:  #stashes-get
[7]:  ../reference/stashes.html#direct-access-to-stash-content-data
[8]:  ../reference/stashes.html#content-attributes
[9]:  ../reference/stashes.html#stash-definition-specification
[10]: https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html
