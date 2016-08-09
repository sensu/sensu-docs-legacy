---
title: "Aggregates API"
version: 0.23
weight: 5
next:
  url: "events-api.html"
  text: "Events API"
---

# Sensu Aggregates API

## Reference documentation

- [The `/aggregates` API endpoint](#the-aggregates-api-endpoint)
  - [`/aggregates` (GET)](#aggregates-get)
- [The `/aggregates/:check` API endpoints](#the-aggregatescheck-api-endpoints)
  - [`/aggregates/:check` (GET)](#aggregatescheck-get)
  - [`/aggregates/:check` (DELETE)](#aggregatescheck-delete)
- [The `/aggregates/:check/:issued` API endpoint](#the-aggregatescheckissued-api-endpoint)
  - [`/aggregates/:check/:issued` (GET)](#aggregatescheckissued-get)


## The `/aggregates` API endpoints

The `/aggregates` API endpoint provides HTTP GET access to [check aggregate
data][1].

### `/aggregates` (GET)

#### EXAMPLES {#aggregates-get-examples}

The following example demonstrates a `/aggregates` API query which results in a
JSON Array of JSON Hashes containing [check aggregates][1].

~~~ shell
$ curl -s http://localhost:4567/aggregates | jq .
[
  {
    "check": "sshd_process",
    "issued": [
      1370738883,
      1370738853
    ]
  },
  {
    "check": "ntp_process",
    "issued": [
      1370738884,
      1370738854
    ]
  }
]
~~~

#### API specification {#aggregates-get-specification}

`/aggregates` (GET)  
: desc
  : Returns the list of aggregates.
: example url
  : http://hostname:4567/aggregates
: parameters
  : - `limit`:
      - **required**: false
      - **type**: Integer
      - **description**: The number of aggregates to return.
    - `offset`:
      - **required**: false
      - **type**: Integer
      - **depends**: `limit`
      - **description**: The number of aggregates to offset before returning items.
: response type
  : Array
: response codes
  : - **Success**: 200 (OK)
    - **Error**: 500 (Internal Server Error)
: output
  : ~~~ json
    [
      {
        "check": "sshd_process",
        "issued": [
          1370738883,
          1370738853
        ]
      },
      {
        "check": "ntp_process",
        "issued": [
          1370738884,
          1370738854
        ]
      }
    ]
    ~~~

## The `/aggregates/:check` API endpoints

The `/aggregates/:check` API endpoints provide HTTP GET and HTTP DELETE access
to [check aggregate data][1] for a named `:check`.

### `/aggregates/:check` (GET)

#### EXAMPLES {#aggregatescheck-get-examples}

The following example demonstrates a `/aggregates/:check` API query for the
check aggregate data for the `:check` named `example_aggregate`, resulting in a
JSON Array of JSON Hashes.

~~~ shell
$ curl -s http://localhost:4567/aggregates | jq .
[
  1370738884,
  1370738854
]
~~~

#### API specification {#aggregatescheck-get-specification}

`/aggregates/:check` (GET)
: desc
  : Returns the list of aggregates for a given check.
: example url
  : http://hostname:4567/aggregates/ntp_process
: parameters
  : - `age`:
      - **required**: false
      - **type**: Integer
      - **description**: The number of seconds old an aggregate must be to be listed.
: response type
  : Array
: response codes
  : - **Success**: 200 (OK)
    - **Missing**: 404 (Not Found)
    - **Error**: 500 (Internal Server Error)
: output
  : ~~~ json
    [
        1370738884,
        1370738854
    ]
    ~~~

### `/aggregates/:check` (DELETE)

#### EXAMPLES {#aggregatescheck-delete-examples}

The following example demonstrates a `/aggregates/:check` API request to delete
check aggregate data for the `:check` named `example_aggregate`, resulting in a
[204 (No Content) HTTP response code][2] (i.e. `HTTP/1.1 204 No Content`).

~~~ shell
$ curl -s -i -X DELETE http://localhost:4567/aggregates/example_aggregate
HTTP/1.1 204 No Content
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Credentials: true
Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization
Connection: close
Server: thin
~~~

#### API specification {#aggregatescheck-delete-specification}

`/aggregates/:check` (DELETE)
: desc
  : Deletes all aggregates for a check.
: example url
  : http://hostname:4567/aggregates/ntp_process
: response type
  : [HTTP-header][3] only (no output)
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

## The `/aggregates/:check/:issued` API endpoints

The `/aggregates/:check/:issued` API endpoint provides HTTP GET access to a
[check aggregate data point][1] for a named `:check` at a specified `:issued`
timestamp.

### `/aggregates/:check/:issued` (GET)

#### EXAMPLES {#aggregatescheckissued-get-examples}

The following example demonstrates a `/aggregates/:check/:issued` API query for
a `:check` aggregate named `example_aggregate` (for the aggregate of results
generated by the check request `:issued` at `1370738854`).

~~~ shell
$ curl -s http://localhost:4567/aggregates/ntp_process/1370738854
{
    "ok": 2,
    "warning": 1,
    "critical": 0,
    "unknown": 1,
    "total": 4
}
~~~  

#### API specification {#aggregatescheckissued-get-specification}

`/aggregates/:check/:issued` (GET)
: desc
  : Returns an aggregate.
: example URL
  : http://hostname:4567/aggregates/ntp_process/1370738854
: parameters
  : - `summarize`:
      - **required**: false
      - **type**: String
      - **description**: Summarizes the output field in the event data. (summarize=output)
    - `results`:
      - **required**: false
      - **type**: Boolean
      - **description**: Return the raw result data.
: response type
  : Hash
: response codes
  : - **Success**: 200 (OK)
    - **Missing**: 404 (Not Found)
    - **Error**: 500 (Internal Server Error)
: output
  : ~~~ json
    {
        "ok": 2,
        "warning": 1,
        "critical": 0,
        "unknown": 1,
        "total": 4
    }
    ~~~

[1]:  ../reference/aggregates.html
[2]:  https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
[3]:  https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html
