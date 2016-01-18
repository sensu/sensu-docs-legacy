---
version: 0.21
category: "API Docs"
title: "Stashes API"
next:
  url: "api-health"
  text: "Health API"
---

# Overview

The Stashes API is used to create, list, and delete stashes (JSON documents) in a key/value store provided by Redis (Sensu's datastore). Stashes are created and then accessible via a "path", which is equivalent to the "key".


## Silence Stashes

Silence stashes are special types of stashes used to silence (prevent handlers from processing) a check or a client. Silence stashes are stashes stored at a path that begins with `"silence/"`. 

####Examples:

* Setting a Stash path to `"silence/<client_name_here>"` will prevent handlers from processing events for a specific client.
* Setting a Stash path to `"silence/<client_name_here>/<check_name_here>"` will prevent handlers from processing events from a specific check on a specific client. 
* Setting a Stash path to `"silence/<client_name_here>/keepalive"` will silence keepalive events for a specific client. 

# API Definition

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
        }
    }
    ~~~

    `expiration`: Stashes can have an expiration, in seconds. The default expiration is never.

    ~~~ json
    {
        "path": "example/stash",
        "content": {
            "message": "example"
        },
        "expire": 60
    }
    ~~~

: response codes
  : - **Success**: 201 (Created)
    - **Malformed**: 400 (Bad Request)
    - **Error**: 500 (Internal Server Error)

_NOTE: When sending the JSON payload to `/stashes`, the payload must contain a 'path' key. If they payload does not contain a 'path' key, the stash path must be provided as part of the request (see below `stashes/:path`)._

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

: response codes
  : - **Success**: 201 (Created)
    - **Malformed**: 400 (Bad Request)
    - **Error**: 500 (Internal Server Error)

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

`/stashes/:path` (DELETE)
: desc
  : Delete a stash. (JSON document)

: example URL
  : http://hostname:4567/stashes/example/stash

: response codes
  : - **Success**: 204 (No Response)
    - **Missing**: 404 (Not Found)
    - **Error**: 500 (Internal Server Error)
