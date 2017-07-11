---
title: "Results API"
version: 1.0
weight: 4
next:
  url: "aggregates-api.html"
  text: "Aggregates API"
---

# Sensu Results API

## Reference documentation

- [The `/results` API endpoint](#the-results-api-endpoint)
  - [`/results` (GET)](#results-get)
  - [`/results` (POST)](#results-post)
- [The `/results/:client` API endpoint](#the-resultsclient-api-endpoint)
  - [`/results/:client` (GET)](#resultsclient-get)
- [The `/results/:client/:check` API endpoints](#the-resultsclientcheck-api-endpoints)
  - [`/results/:client/:check` (GET)](#resultsclientcheck-get)
  - [`/results/:client/:check` (DELETE)](#resultsclientcheck-delete)

## The `/results` API endpoint

The `/results` API endpoint provides HTTP GET and HTTP POST access to current
[check result data][1].

### `/results` (GET)

The `/results` API endpoint provides HTTP GET access to fetch current [check
result data][1].

#### EXAMPLES {#results-get-examples}

The following example demonstrates a `/results` API query which returns a JSON
Array of JSON Hashes containing [check results][1].

~~~ shell
$ curl -s http://localhost:4567/results | jq .
[
  {
    "check": {
      "status": 1,
      "output": "CheckHttp WARNING: 301\n",
      "command": "check-http.rb -u :::website|http://sensuapp.org:::",
      "subscribers": [
        "production"
      ],
      "interval": 60,
      "handler": "mail",
      "name": "sensu_website",
      "issued": 1460312322,
      "executed": 1460312322,
      "duration": 0.032
    },
    "client": "client-01"
  },
  {
    "check": {
      "status": 0,
      "output": "Keepalive sent from client 2 seconds ago",
      "executed": 1460312365,
      "issued": 1460312365,
      "name": "keepalive",
      "thresholds": {
        "critical": 180,
        "warning": 120
      }
    },
    "client": "client-01"
  }
]
~~~

#### API specification {#results-get-specification}

`/results` (GET)
: desc
  : Returns a list of current check results for all clients.

: example url
  : http://hostname:4567/results

: response type
  : Array

: response codes
  : - **Success**: 200 (OK)
    - **Error**: 500 (Internal Server Error)

: output
  : ~~~ json
    [
        {
            "client": "i-424242",
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
                "duration": 0.032
            }
        }
    ]
    ~~~

### `/results` (POST)

The `/results` API endpoint provides HTTP POST access to submit [check result
data][1].

#### EXAMPLES {#results-post-examples}

The following example demonstrates submitting an HTTP POST to the `/results` API
with JSON Hash payload containing [check result data][1], resulting in a [202
(Accepted) HTTP response code][2] (i.e. `HTTP/1.1 202 Accepted`) and a JSON Hash
containing an `issued` timestamp.

~~~ shell
$ curl -s -i -X POST \
-H 'Content-Type: application/json' \
-d '{"source": "external_service", "name": "check_external", "output": "hello results API world", "status": 0}' \
http://localhost:4567/results

HTTP/1.1 202 Accepted
Content-Type: application/json
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Credentials: true
Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization
Content-Length: 21
Connection: keep-alive
Server: thin

{"issued":1460326288}
~~~

#### API specification {#results-post-specification}

`/results` (POST)
: desc
  : Accepts [Sensu check result data][4] via API.
: example url
  : http://hostname:4567/results
: response type
  : [HTTP-header][3] only (no output)
: response codes
  : - **Success**: 201 (Created)
    - **Malformed**: 400 (Bad Request)
    - **Error**: 500 (Internal Server Error)
: example payload
  : ~~~
     {
       "source": "docker_01",
       "name": "index_app_01",
       "output": "Indexing app is OK",
       "status": 0
     }
    ~~~
    _NOTE: the `/results` (POST) API only supports check `name`, `output`,
    `status`, and `source` (used to create a [proxy client][4]). Please see the
    [check definition specification][5] documentation for more information._
: output
  : ~~~ shell
    HTTP/1.1 202 Accepted
    Content-Type: application/json
    Access-Control-Allow-Origin: *
    Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
    Access-Control-Allow-Credentials: true
    Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization
    Content-Length: 21
    Connection: keep-alive
    Server: thin

    {"issued":1460326288}
    ~~~

## The `/results/:client` API endpoint

### `/results/:client` (GET)

The `/results/:client` API endpoint provides HTTP GET access to [check result
data][1] for a specific `:client`.

#### EXAMPLES {#resultsclient-get-examples}

The following example demonstrates a `/results/:client` API query which returns
a JSON Array of JSON Hashes containing [check results][1] for the `:client`
named `client-01`.

~~~ shell
$ curl -s http://localhost:4567/results/client-01 | jq .
[
  {
    "check": {
      "status": 1,
      "output": "CheckHttp WARNING: 301\n",
      "command": "check-http.rb -u :::website|http://sensuapp.org:::",
      "subscribers": [
        "production"
      ],
      "interval": 60,
      "handler": "mail",
      "name": "sensu_website",
      "issued": 1460312322,
      "executed": 1460312322,
      "duration": 0.032
    },
    "client": "client-01"
  },
  {
    "check": {
      "status": 0,
      "output": "Keepalive sent from client 2 seconds ago",
      "executed": 1460312365,
      "issued": 1460312365,
      "name": "keepalive",
      "thresholds": {
        "critical": 180,
        "warning": 120
      }
    },
    "client": "client-01"
  }
]
~~~

#### API specification {#resultsclient-get-specification}

`/results/:client` (GET)
: desc
  : Returns a list of current check results for a given client.
: example url
  : http://hostname:4567/results/i-424242
: response type
  : Array
: response codes
  : - **Success**: 200 (OK)
    - **Error**: 500 (Internal Server Error)
: output
  : ~~~ json
    [
        {
            "client": "i-424242",
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
                "duration": 0.032
            }
        }
    ]
    ~~~

## The `/results/:client/:check` API endpoints

The `/results/:client/:check` API endpoint provides HTTP GET and HTTP DELETE
access to [check result data][1] for a named `:client` and `:check`.

### `/results/:client/:check` (GET)

#### EXAMPLES {#resultsclientcheck-get-examples}

The following example demonstrates a `/results/:client/:check` API query which
returns a JSON Hash containing the most recent [check result][1] for the
`:client` named `client-01` and the `:check` named `:`.

~~~ shell
$ curl -s http://localhost:4567/results/client-01/sensu_website | jq .
{
  "check": {
    "status": 1,
    "output": "CheckHttp WARNING: 301\n",
    "command": "check-http.rb -u :::website|http://sensuapp.org:::",
    "subscribers": [
      "production"
    ],
    "interval": 60,
    "handler": "mail",
    "name": "sensu_website",
    "issued": 1460312622,
    "executed": 1460312622,
    "duration": 0.032
  },
  "client": "client-01"
}
~~~

#### API specification {#resultsclientcheck-get-specification}

`/results/:client/:check` (GET)
: desc
  : Returns a check result for a given client & check name.
: example url
  : http://hostname:4567/results/i-424242/chef_client_process
: response type
  : Hash
: response codes
  : - **Success**: 200 (OK)
    - **Missing**: 404 (Not Found)
    - **Error**: 500 (Internal Server Error)
: output
  : ~~~ json
    {
        "client": "i-424242",
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
            "duration": 0.032
        }
    }
    ~~~

### `/results/:client/:check` (DELETE)

#### EXAMPLES {#resultsclientcheck-delete-examples}

The following example demonstrates a `/results/:client/:check` request to delete
check result data for a `:client` named `client-01` and a `:check` named
`sensu_website`, resulting in a [204 (No Content) HTTP response code][2] (i.e.
`HTTP/1.1 204 No Content`), indicating that the result was successful, but that
no content is provided as output.

~~~ shell
curl -s -i -X DELETE http://localhost:4567/results/client-01/sensu_website
HTTP/1.1 204 No Content
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Credentials: true
Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization
Connection: close
Server: thin
~~~

#### API specification {#resultsclientcheck-delete-specification}

`/results/:client/:check` (DELETE)
: desc
  : Delete a check result for a given client & check name.
: example url
  : http://hostname:4567/results/i-424242/chef_client_process
: response type
  : [HTTP-header][3] only (No Content)
: response codes
  : - **Success**: 204 (No Content)
    - **Missing**: 404 (Not Found)
    - **Error**: 500 (Internal Server Error)
: output
  : ~~~ shell
    HTTP/1.1 204 No Content
    Access-Control-Allow-Origin: *
    Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
    Access-Control-Allow-Credentials: true
    Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization
    Connection: close
    Server: thin
    ~~~

[?]:  #
[1]:  ../reference/checks.html#check-results
[2]:  https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
[3]:  https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html
[4]:  ../reference/clients.html#proxy-clients
[5]:  ../reference/checks.html#check-definition-specification
