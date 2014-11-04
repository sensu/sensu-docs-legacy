---
version: "0.15"
category: "API"
title: "API stashes"
---

# API Stashes

Create, list, and delete stashes (JSON documents). The stashes
endpoint is an HTTP key/value data store.

## `/stashes` {#stashes}

* `GET`: returns a list of stashes

  - Parameters

    - `limit`

      - optional

      - value: integer

      - description: "The number of stashes to return."

    - `offset`

      - optional

      - value: integer

      - depends: `limit`

      - description: "The number of stashes to offset before returning items."

  - success: 200:

    ~~~ json
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
  - error: 500

* `POST`: create a stash (JSON document)

  - payload:

    ~~~ json
    {
        "path": "example/stash",
        "content": {
            "message": "example"
        }
    }
    ~~~

  - expiration: stashes can have an expiration, in seconds, the
    default is never.

    ~~~ json
    {
        "path": "example/stash",
        "content": {
            "message": "example"
        },
        "expire": 60
    }
    ~~~

  - success: 201

  - error: 500

## `/stashes/:path` {#stashes-path}

Example URL: `http://hostname:4567/stashes/example/stash`

* `POST`: create a stash (JSON document)

  - payload:

    ~~~ json
    {
        "message": "example"
    }
    ~~~

  - success: 201

  - malformed: 400

  - error: 500

* `GET`: get a stash (JSON document)

  - success: 200:

    ~~~ json
    {
        "message": "example"
    }
    ~~~

  - missing: 404

  - error: 500

* `DELETE`: delete a stash

  - success: 204

  - missing: 404

  - error: 500
