---
layout: default
title: stashes
description: The Sensu API
version: '0.11'
---

<div class="page-header">
  <h1>Stashes API Endpoint<small></small></h1>
</div>

The stashes endpoints allows you to create, list and delete stashes.

## `/stashes`

example url - http://localhost:4567/stashes

* `GET`: returns a list of stash paths

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

             [
               {
                 "path": "silence/machine1/service1",
                 "content": {
                   "timestamp": 1383441836
                 },
                 "expire": 10054
               },
               {
                 "path": "silence/machine2",
                 "content": {
                   "timestamp": 1381350802
                 },
                 "expire": -1
               }
             ]

  - error: 500

* `POST`: Create a stash (JSON document)

  - payload:

             {
               "path": "random_stash",
               "content": {
                 "reason": "things are stashy"
               },
               "expire": 86400
             }

  - success: 201

  - error: 500

## `/stashes/:path`

example url - http://localhost:4567/stashes/foo

* `POST`: create a stash (JSON document)

  - payload:

             {
               "bar": 42
             }

  - success: 201

  - malformed: 400

  - error: 500

* `GET`: get a stash (JSON document)

  - success: 200:

             {
               "bar": 42
             }

  - missing: 404

  - error: 500

* `DELETE`: delete a stash (JSON document)

  - success: 204

  - missing: 404

  - error: 500
