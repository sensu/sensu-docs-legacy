---
title: "Events API"
version: 0.23
weight: 6
next:
  url: "stashes-api.html"
  text: "Stashes API"
---

# Sensu Events API

## Reference documentation

- [The `/events` API endpoint](#the-events-api-endpoint)
  - [`/events` (GET)](#events-get)
- [The `/events/:client` API endpoint](#the-eventsclient-api-endpoint)
  - [`/events/:client` (GET)](#eventsclient-get)
- [The `/events/:client/:check` API endpoints](#the-eventsclientcheck-api-endpoints)
  - [`/events/:client/:check` (GET)](#eventsclientcheck-get)
  - [`/events/:client/:check` (DELETE)](#eventsclientcheck-delete)
- [The `/resolve` API endpoint](#the-resolve-api-endpoint)
  - [`/resolve` (POST)](#resolve-post)

## The `/events` API endpoint

### `/events` (GET)

The `/events` API endpoint provide HTTP GET access to the Sensu event registry.

#### EXAMPLES {#events-get-examples}

The following example demonstrates a `/events` API query which returns a JSON
Array of JSON Hashes containing [event data][1].

~~~ shell
$ curl -s http://localhost:4567/events | jq .
[
  {
    "timestamp": 1460303502,
    "action": "create",
    "occurrences": 1,
    "check": {
      "total_state_change": 14,
      "history": [
        "0",
        "3",
        "3",
        "3",
        "3",
        "3",
        "3",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "1"
      ],
      "status": 1,
      "output": "CheckHttp WARNING: 301\n",
      "command": "check-http.rb -u :::website|http://sensuapp.org:::",
      "subscribers": [
        "production"
      ],
      "interval": 60,
      "handler": "mail",
      "name": "sensu_website",
      "issued": 1460303502,
      "executed": 1460303502,
      "duration": 0.271
    },
    "client": {
      "timestamp": 1460303501,
      "version": "0.23.0",
      "website": "http://google.com",
      "socket": {
        "port": 3030,
        "bind": "127.0.0.1"
      },
      "subscriptions": [
        "production"
      ],
      "environment": "development",
      "address": "127.0.0.1",
      "name": "client-01"
    },
    "id": "0f42ec94-12bf-4918-a0b9-52fd57e8ee96"
  }
]
~~~

#### API specification {#events-get-specification}

`/events` (GET)
: desc
  : Returns the list of current events.
: example url
  : http://hostname:4567/events
: response type
  : Array
: response codes
  : - **Success**: 200 (OK)
    - **Error**: 500 (Internal Server Error)
: output
  : ~~~ json
    [
        {
            "id": "1ccfdf59-d9ab-447c-ac11-fd84072b905a",
            "client": {
                "name": "i-424242",
                "address": "127.0.0.1",
                "subscriptions": [
                    "webserver",
                    "production"
                ],
                "timestamp": 1389374650
            },
            "check": {
                "name": "chef_client_process",
                "command": "check-procs -p chef-client -W 1",
                "subscribers": [
                    "production"
                ],
                "interval": 60,
                "issued": 1389374667,
                "executed": 1389374667,
                "output": "WARNING Found 0 matching processes\n",
                "status": 1,
                "duration": 0.005,
                "history": [
                    "0",
                    "1",
                    "1"
                ]
            },
            "occurrences": 2,
            "action": "create"
        }
    ]
    ~~~

## The `/events/:client` API endpoint

### `/events/:client` (GET)

The `/events/:client` API endpoint provide HTTP GET access to current [event
data][1] for a specific client in the Sensu event registry, by `:client` name.

#### EXAMPLES {#eventsclient-get-examples}

The following example demonstrates a `/events/:client` API query which returns a
JSON Array of JSON Hashes containing current [event data][1] for the `:client`
named `client-01`.

~~~ shell
$ curl -s http://localhost:4567/events/client-01 | jq .
[
  {
    "timestamp": 1460303742,
    "action": "create",
    "occurrences": 5,
    "check": {
      "total_state_change": 9,
      "history": [
        "3",
        "3",
        "3",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "1",
        "1",
        "1",
        "1",
        "1"
      ],
      "status": 1,
      "output": "CheckHttp WARNING: 301\n",
      "command": "check-http.rb -u :::website|http://sensuapp.org:::",
      "subscribers": [
        "production"
      ],
      "interval": 60,
      "handler": "mail",
      "name": "sensu_website",
      "issued": 1460303742,
      "executed": 1460303742,
      "duration": 0.26
    },
    "client": {
      "timestamp": 1460303741,
      "version": "0.23.0",
      "website": "http://google.com",
      "socket": {
        "port": 3030,
        "bind": "127.0.0.1"
      },
      "subscriptions": [
        "production"
      ],
      "environment": "development",
      "address": "127.0.0.1",
      "name": "client-01"
    },
    "id": "588a2932-6c12-4222-8118-00ba40625149"
  }
]
~~~

#### API specification {#eventsclient-get-specification}

`/events/:client` (GET)
: desc
  : Returns the list of current events for a given client.
: example url
  : http://hostname:4567/events/i-424242
: response type
  : Array
: response codes
  : - **Success**: 200 (OK)
    - **Error**: 500 (Internal Server Error)
: output
  : ~~~ json
    [
        {
            "id": "1ccfdf59-d9ab-447c-ac11-fd84072b905a",
            "client": {
                "name": "i-424242",
                "address": "127.0.0.1",
                "subscriptions": [
                    "webserver",
                    "production"
                ],
                "timestamp": 1389374650
            },
            "check": {
                "name": "chef_client_process",
                "command": "check-procs.rb -p chef-client -W 1",
                "subscribers": [
                    "production"
                ],
                "interval": 60,
                "issued": 1389374667,
                "executed": 1389374667,
                "output": "WARNING Found 0 matching processes\n",
                "status": 1,
                "duration": 0.005,
                "history": [
                    "0",
                    "1",
                    "1"
                ]
            },
            "occurrences": 2,
            "action": "create"
        }
    ]
    ~~~

## The `/events/:client/:check` API endpoints

The `/events/:client/:check` API provides HTTP GET and HTTP DELETE access to
current [event data][1] for a named `:client` and `:check`.

### `/events/:client/:check` (GET)

#### EXAMPLES {#eventsclientcheck-get-examples}

The following example demonstrates a `/events/:client/:check` API query which
returns a JSON Hash containing [event data][1] for a `:client` named `client-01`
and a `:check` named `sensu_website`.

~~~ shell
$ curl -s http://localhost:4567/events/client-01/sensu_website | jq .
{
  "timestamp": 1460304102,
  "action": "create",
  "occurrences": 11,
  "check": {
    "total_state_change": 5,
    "history": [
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "1",
      "1",
      "1",
      "1",
      "1",
      "1",
      "1",
      "1",
      "1",
      "1",
      "1"
    ],
    "status": 1,
    "output": "CheckHttp WARNING: 301\n",
    "command": "check-http.rb -u :::website|http://sensuapp.org:::",
    "subscribers": [
      "production"
    ],
    "interval": 60,
    "handler": "mail",
    "name": "sensu_website",
    "issued": 1460304102,
    "executed": 1460304102,
    "duration": 0.269
  },
  "client": {
    "timestamp": 1460304101,
    "version": "0.23.0",
    "website": "http://google.com",
    "socket": {
      "port": 3030,
      "bind": "127.0.0.1"
    },
    "subscriptions": [
      "production"
    ],
    "environment": "development",
    "address": "127.0.0.1",
    "name": "client-01"
  },
  "id": "07246570-8335-414e-8720-db6616fe5c40"
}
~~~

#### API specification {#eventsclientcheck-get-specification}

`/events/:client/:check` (GET)
: desc
  : Returns an event for a given client & check name.
: example url
  : http://hostname:4567/events/i-424242/chef_client_process
: response type
  : Hash
: response codes
  : - **Success**: 200 (OK)
    - **Missing**: 404 (Not Found)
    - **Error**: 500 (Internal Server Error)
: output
  : ~~~ json
    {
        "id": "1ccfdf59-d9ab-447c-ac11-fd84072b905a",
        "client": {
            "name": "i-424242",
            "address": "127.0.0.1",
            "subscriptions": [
                "webserver",
                "production"
            ],
            "timestamp": 1389374650
        },
        "check": {
            "name": "chef_client_process",
            "command": "check-procs.rb -p chef-client -W 1",
            "subscribers": [
                "production"
            ],
            "interval": 60,
            "issued": 1389374667,
            "executed": 1389374667,
            "output": "WARNING Found 0 matching processes\n",
            "status": 1,
            "duration": 0.005,
            "history": [
                "0",
                "1",
                "1"
            ]
        },
        "occurrences": 2,
        "action": "create"
    }
    ~~~

### `/events/:client/:check` (DELETE)

#### EXAMPLES {#eventsclientcheck-delete-examples}

The following example demonstrates a `/events/:client/:check` API request to
to delete event data for a `:client` named `:client-01` and a `:check` named
`sensu_website`, resulting in a [202 (Accepted) HTTP response code][2] (i.e.
`HTTP/1.1 202 Accepted`) and a payload containing a JSON Hash with the delete
request `issued` timestamp.

~~~ shell
curl -s -i -X DELETE http://localhost:4567/events/client-01/sensu_website
HTTP/1.1 202 Accepted
Content-Type: application/json
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Credentials: true
Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization
Content-Length: 21
Connection: keep-alive
Server: thin

{"issued":1460304359}
~~~

#### API specification {#eventsclientcheck-delete-specification}

`/events/:client/:check` (DELETE)
: desc
  : Resolves an event for a given check on a given client. (delayed action)

: example url
  : http://hostname:4567/events/i-424242/chef_client_process

: response codes
  : - **Success**: 202 (Accepted)
    - **Missing**: 404 (Not Found)
    - **Error**: 500 (Internal Server Error)

## The `/resolve` API endpoint

### `resolve` (POST)

The `/resolve` API endpoint provides HTTP POST access to resolve current [Sensu
events][3].

#### EXAMPLES {#resolve-post-examples}

The following example demonstrates a `/resolve` API request to resolve an event
for a client named `client-01` and a check named `sensu_website`, which results
in a [202 (Accepted) HTTP response code][2] (i.e. `HTTP/1.1 202 Accepted`) and a
payload containing a JSON Hash with the resolve requests `issued` timestamp.

~~~ shell
$ curl -s -i -X POST \
-H 'Content-Type: application/json' \
-d '{"client": "client-01", "check": "sensu_website"}' \
http://localhost:4567/resolve

HTTP/1.1 202 Accepted
Content-Type: application/json
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Credentials: true
Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization
Content-Length: 21
Connection: keep-alive
Server: thin

{"issued":1460311425}
~~~

The following example demonstrates a `/resolve` API request to resolve an event
for a non-existent client named `non-existent-client` and a check named
`non-existent-check`, resulting in a [404 (Not Found) HTTP response code][2].

~~~ shell
curl -s -i -X POST \
-H 'Content-Type: application/json' \
-d '{"client": "non-existent-client", "check": "non-existent-check"}' \
http://localhost:4567/resolve

HTTP/1.1 404 Not Found
Content-Type: application/json
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Credentials: true
Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization
Content-Length: 0
Connection: keep-alive
Server: thin
~~~

#### API specification {#resolve-post-specification}

`/resolve` (POST)
: desc.
  : Resolves an event. (delayed action)

: example url
  : http://hostname:4567/resolve

: payload
  : ~~~ json
    {
        "client": "i-424242",
        "check": "chef_client_process"
    }
    ~~~

: response codes
  : - **Success**: 202 (Accepted)
    - **Missing**: 404 (Not Found)
    - **Malformed**: 400 (Bad Request)
    - **Error**: 500 (Internal Server Error)

[1]:  ../reference/events.html#event-data
[2]:  https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
[3]:  ../reference/events.html
