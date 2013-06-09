---
layout: default
title: stashes
description: The Sensu API
version: 0.9
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
               "foo",
               "bar"
             ]

  - error: 500

* `POST`: returns multiple stashes (JSON documents)

  - payload:

             [
               "foo",
               "bar"
             ]

  - success: 200:

             {
               "foo": {
                 "bar": 42
               },
               "bar": {
                 "foo": 73
               }
             }

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
