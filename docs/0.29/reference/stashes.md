---
title: "Stashes"
description: "Reference documentation for Sensu Stashes."
version: 0.28
weight: 11
---

# Sensu Stashes

## Reference documentation

- [What is a Sensu stash?](#what-is-a-sensu-stash)
  - [The Sensu key/value store](#the-sensu-keyvalue-store)
- [The Sensu stash specification](#the-sensu-stash-specification)
  - [Example Sensu stash](#example-sensu-stash)
  - [Stash definition specification](#stash-definition-specification)
    - [Stash attributes](#stash-attributes)
    - [`content` attributes](#content-attributes)
      - [Direct access to stash `content` data](#direct-access-to-stash-content-data)

## What is a Sensu stash?

A Sensu stash is a JSON document containing arbitrary JSON Hash data which is
accessible via the [Stashes API][1]. The most common use of the Sensu Stashes
are via Sensu handlers, which may access the Stashes API to create and/or read
"state" information that persists between handler executions.

### The Sensu key/value store

The [Stashes API][1] provides a [key/value store][1] for Sensu, where arbitrary
JSON data (i.e. the "values") can be created, accessed, and deleted via an
arbitrary `path` (i.e. the "keys").

## The Sensu stash specification

### Example Sensu stash

The following is an example Sensu stash.

~~~ json
{
  "path": "path/to/my/stash",
  "content": {
    "message": "hello world!",
    "foo": "bar"
  },
  "expire": -1
}
~~~

### Stash definition specification

#### Stash attributes

`path`
: desc
  : The path (or "key") the stash will be created and/or accessible at.
: type
  : String
: required
  : true
: example
  : ~~~
    "path": "silence/server-01"
    ~~~

`content`
: desc
  : Arbitrary JSON data.
: type
  : Hash
: required
  : false
: example
  : ~~~
    "content": {
      "message": "hello world!"
    }
    ~~~  

`expire`
: desc
  : How long should the stash exist before it is removed by the API, in seconds
: type
  : Integer
: required
  : false
: default
  : `-1`
: example
  : ~~~
    "expire": 3600
    ~~~

#### `content` attributes

By default (i.e. if no `content` is provided), Sensu stash `content` is an empty
JSON Hash (i.e. `{}`). Because stashes are just JSON documents, it is possible
to define arbitrary JSON data inside the `content` Hash in a similar fashion as
custom attributes may be defined for other Sensu primitives (e.g. clients,
checks, etc).

_NOTE: no built-in Sensu features define a specification for stash `content`, so
there are no "supported" stash formats &mdash; all Sensu stashes are treated as
custom data._

##### Direct access to stash `content` data

It is important to note that the [Stashes API][1] provides multiple endpoints
for access Sensu stash data (e.g. `/stashes` and `/stashes/:path`). While the
`/stashes` API endpoints provide access to complete [stash definitions][2], the
`/stashes/:path` endpoints provide **direct access to stash `content` data**.

Please note the following example exercise to demonstrate the effect of direct
access to stash `content` data:

1. Let's assume we're starting out with an empty [key/value store][4].

   ~~~ shell
   $ curl -s http://localhost:4567/stashes | jq .
   []
   ~~~

2. Now let's create a stash with a path called 'direct-access/example-1' via the
   [`/stashes` (POST) API][5]:

   ~~~ shell
   $ curl -s -i -X POST \
   -H 'Content-Type: application/json' \
   -d '{"path": "direct-access/example-1", "content":{"message":"hello world"}}' \
   http://localhost:4567/stashes

   HTTP/1.1 201 Created
   Content-Type: application/json
   Access-Control-Allow-Origin: *
   Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
   Access-Control-Allow-Credentials: true
   Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization
   Content-Length: 32
   Connection: keep-alive
   Server: thin

   {"path":"direct-access/example-1"}
   ~~~

3. Now let's create a stash with a path called `direct-access/example-2` via the
   [`/stashes/:path` (POST) API][6] (i.e. using **direct access to stash
   `content` data**):

   ~~~ shell
   $ curl -s -i -X POST \
   -H 'Content-Type: application/json' \
   -d '{"message": "hello world"}' \
   http://localhost:4567/stashes/direct-access/example-2

   HTTP/1.1 201 Created
   Content-Type: application/json
   Access-Control-Allow-Origin: *
   Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
   Access-Control-Allow-Credentials: true
   Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization
   Content-Length: 32
   Connection: keep-alive
   Server: thin

   {"path":"direct-access/example-2"}
   ~~~

   _NOTE: in the above example, we are not providing a complete [stash
   definition][2] (e.g. defining the `path` and `content` attributes), because
   the `/stashes/:path` API provides **direct access to stash `content` data**._

4. Now let's see what our stashes looks like:

   ~~~ shell
   $ curl -s http://localhost:4567/stashes | jq .
   [
     {
       "expire": -1,
       "content": {
         "message": "hello world"
       },
       "path": "direct-access/example-1"
     },
     {
       "expire": -1,
       "content": {
         "message": "hello world"
       },
       "path": "direct-access/example-2"
     }
   ]
   ~~~

   As you can see, even though we didn't provide a complete stash definition in
   step 3, the resulting stash is the same format as the stash created in step
   2.

[?]:  #
[1]:  ../api/stashes-api.html
[2]:  #stash-definition-specification
[3]:  #content-attributes
[4]:  #the-sensu-keyvalue-store
[5]:  ../api/stashes-api.html#stashes-post
[6]:  ../api/stashes-api.html#stashespath-post
