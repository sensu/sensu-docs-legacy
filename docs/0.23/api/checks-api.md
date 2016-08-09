---
title: "Checks API"
version: 0.23
weight: 3
next:
  url: "results-api.html"
  text: "Results API"
---

# Sensu Checks API

## Reference documentation

- [The `/checks` API endpoint](#the-checks-api-endpoint)
  - [`/checks` (GET)](#checks-get)
- [The `/checks/:check` API endpoint(s)](#the-checkscheck-api-endpoints)
  - [`/checks/:check` (GET)](#checkscheck-get)
- [The `/request` API endpoint](#the-request-api-endpoint)
  - [`/request` (POST)](#request-post)

## The `/checks` API endpoint

### `/checks` (GET)

The `/checks` API endpoint provides HTTP GET access to [subscription check][1]
data.

#### EXAMPLE {#checks-get-example}

The following example demonstrates a request to the `/checks` API, resulting in
a JSON Array of JSON Hashes containing subscription [check definitions][2].

~~~ shell
$ curl -s http://127.0.0.1:4567/checks | jq .
[
  {
    "name": "sensu_website",
    "interval": 60,
    "subscribers": [
      "production"
    ],
    "command": "check-http.rb -u https://sensuapp.org"
  }
]
~~~

#### API Specification {#checks-get-specification}

`/checks` (GET)
: desc.
  : Returns the list of checks.

: example url
  : http://hostname:4567/checks

: response type
  : Array

: response codes
  : - **Success**: 200 (OK)
    - **Error**: 500 (Internal Server Error)

: output
  : ~~~ json
    [
        {
            "name": "chef_client_process",
            "command": "check-procs.rb -p /usr/bin/chef-client -W 1 -w 2 -c 3",
            "subscribers": [
                "production"
            ],
            "interval": 60
        },
        {
            "name": "website",
            "command": "check-http.rb -h localhost -p /health -P 80 -q Passed -t 30",
            "subscribers": [
                "webserver"
            ],
            "interval": 30
        }
    ]
    ~~~

## The `/checks/:check` API endpoint(s)

### `/checks/:check` (GET)

The `/checks/:check` API endpoints provide HTTP GET access to
[subcription check data][1] for specific `:check` definitions, by check `name`.

#### EXAMPLE {#checkscheck-get-example}

In the following example, querying the `/checks/:check` API returns a JSON Hash
containing the requested [`:check` definition][2] (i.e. for the `:check` named
`sensu_website`).

~~~ shell
$ curl -s http://127.0.0.1:4567/checks/sensu_website | jq .
{
  "name": "sensu_website",
  "interval": 60,
  "subscribers": [
    "production"
  ],
  "command": "check-http.rb -u https://sensuapp.org"
}
~~~

The following example demonstrates a request for check data for a non-existent
`:check` named `non_existent_check`, which results in a [404 (Not Found) HTTP
response code][3] (i.e. `HTTP/1.1 404 Not Found`).

~~~ shell
$ curl -s -i http://127.0.0.1:4567/checks/non_existent_check

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

#### API Specification {#checkscheck-get-specification}

`/checks/:check` (GET)
: desc.
  : Returns a check.

: example url
  : http://hostname:4567/checks/sensu_website

: response type
  : Hash

: response codes
  : - **Success**: 200 (OK)
    - **Missing**: 404 (Not Found)
    - **Error**: 500 (Internal Server Error)

: output
  : ~~~ json
    {
        "name": "chef_client_process",
        "command": "check-procs.rb -p /usr/bin/chef-client -W 1 -w 2 -c 3",
        "subscribers": [
            "production"
        ],
        "interval": 60
    }
    ~~~

## The `/request` API endpoint

### `/request` (POST)

The `/request` API provides HTTP POST access to publish [subscription check][1]
requests via the Sensu API.

#### EXAMPLE {#request-post-example}

In the following example, an HTTP POST is submitted to the `/request` API,
requesting a check execution for the `sensu_website` [subscription check][1],
resulting in a [202 (Accepted) HTTP response code][3] (i.e. `HTTP/1.1 202
Accepted`) and a JSON Hash containing an `issued` timestamp.

~~~ shell
curl -s -i \
-X POST \
-H 'Content-Type: application/json' \
-d '{"check": "sensu_website"}' \
http://127.0.0.1:4567/request

HTTP/1.1 202 Accepted
Content-Type: application/json
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Credentials: true
Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization
Content-Length: 21
Connection: keep-alive
Server: thin

{"issued":1460142533}
~~~

_PRO TIP: the `/request` API can be a powerful utility when combined with check
definitions that are configured with `"publish": false` (i.e. checks which are
not intended to run on a scheduled interval). Using `"publish": false` along
with the `/request` API makes it possible to request predefined check executions
on an as-needed basis._

The following example demonstrates a request for a check execution for a
non-existent check named `non_existent_check`, which results in a [404 (Not
Found) HTTP response code][3] (i.e. `HTTP/1.1 404 Not Found`).

~~~ shell
curl -s -i \
-X POST \
-H 'Content-Type: application/json' \
-d '{"check": "non_existent_check"}' \
http://127.0.0.1:4567/request

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

#### API Specification {#request-post-specification}

`/request` (POST)
: desc.
  : Issues a check execution request.

: example url
  : http://hostname:4567/request

: payload
  : ~~~ json
    {
      "check": "chef_client_process",
      "subscribers": [
        "production"
      ]
    }
    ~~~

    _NOTE: the `subscribers` attribute is not required for requesting a check
    execution, however it may be provided to override the `subscribers` [check
    definition attribute][2]. No other check definition attribute overrides are
    supported via the `/request` API._

: response codes
  : - **Success**: 202 (Accepted)
    - **Malformed**: 400 (Bad Request)
    - **Error**: 500 (Internal Server Error)

[?]:  #
[1]:  ../reference/checks.html#subscription-checks
[2]:  ../reference/checks.html#check-configuration
[3]:  https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
