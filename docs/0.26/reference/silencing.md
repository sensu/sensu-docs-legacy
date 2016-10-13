---
title: "Silencing"
description: "Reference documentation for Sensu Event Silencing."
version: 0.26
weight: 6
---

# Sensu Silencing

## Reference documentation

- [What is Sensu Silencing?](#what-is-sensu-silencing)
  - [When to use silencing](#when-to-use-silencing)
  - [Advantages over deprecated stash-based silencing](#advantages-over-deprecated-stash-based-silencing)
- [How does silencing work?](#how-does-silencing-work)
- [Silencing entry specification](#silencing-entry-specification)
  - [Silencing entry attributes](#silencing-entry-attributes)
- [Examples](#examples)
  - [Silence all checks on a specific client](#silence-all-checks-on-a-specific-client)
  - [Silence a specific check on a specific client](#silence-a-specific-check-on-a-specific-client)
  - [Silence all checks on clients with a specific subscription](#silence-all-checks-on-clients-with-a-specific-subscription)
  - [Silence a specific check on clients with a specific subscription](#silence-a-specific-check-on-clients-with-a-specific-subscription)
  - [Deleting (clearing) silencing entries](#deleting-clearing-silencing-entries)

## What is Sensu Silencing?

Silencing is the means to suppress the execution of [handlers][1] on an ad-hoc
basis. By creating entries in the `silenced` registry using the [Silenced
API][2], either manually or via a dashboard, Sensu operators and on-call
personnel can mute notifications on-the-fly.

Entries in the `silenced` registry (or "silencing entries") describe a
combination of check name and subscription. When the check name and subscription
described in a silencing entry match an event which would otherwise be passed to
a handler, the handler will not be executed and an informational message will be
logged. Individual handlers may opt-out of silencing by configuring the
[`handle_silenced` attribute][3].

_NOTE: Silencing described in this reference document is implemented in Sensu
version 0.26 or later and Sensu Enterprise 2.0 or later._

### When to use silencing

Silencing is used to prevent handlers from being triggered based on the check
name, subscription or client name present in a check result. This can be
desirable in many scenarios, giving operators the ability to quiet incoming
alerts while coordinating their response.

Sensu silencing entries make it possible to:

* [Silence all checks on a specific client](#silence-all-checks-on-a-specific-client)
* [Silence a specific check on a specific client](#silence-a-specific-check-on-a-specific-client)
* [Silence all checks on clients with a specific subscription](#silence-all-checks-on-clients-with-a-specific-subscription)
* [Silence a specific check on clients with a specific subscription](#silence-a-specific-check-on-clients-with-a-specific-subscription)

In addition to the above combinations, silencing entries support

* Expire after a specified number of seconds
* Expire after check returns to OK state
* Describe the "reason" or rationale
* Describe the "creator" or entity responsible for an entry

### Advantages over deprecated stash-based silencing

Prior to Sensu 0.26, silencing capability was implemented in external libraries
like [sensu-plugin][1] using [Sensu Stashes][0]. Although silencing via stashes
has not been removed from sensu-plugin, it is effectively deprecated by the
introduction of native silencing as described in this document.

Native silencing offers the following advantages over the stash-based silencing
model which preceded it:

* Lower overhead - does not require forking a handler process to access the API
* Works for any handler regardless of language; no dependency on sensu-plugin
or similar libraries.
* Handlers can opt out of silencing via configuration (`"handle_silenced": true`).
* Silencing can be applied to clients not yet registered with the system by
targeting subscriptions instead of client names.
* Silencing entries can be automatically removed once the corresponding check
returns OK

## How does silencing work?

Silencing entries are created on an ad-hoc basis via the [Silenced API][2]
endpoint. When silencing entries are successfully created via the API, they
are assigned an ID in the format `$SUBSCRIPTION:$CHECK`, where `$SUBSCRIPTION`
is the name of a Sensu client subscription and `$CHECK` is the name of a Sensu
check.

These silencing entries are persisted to the `silenced` registry in the Sensu
data store. When the Sensu server process subsequent check results, it consults
this registry to determine whether or not a matching silencing entry exists. If
one or more matching entries exist in the registry, the event context for the
check result is updated to indicate that the event is silenced and the ID of the
entries which the check result matched.

When creating a silencing entry, a combination of check and subscription can
be specified, but only one or the other is strictly required.

For example, when a silencing entry is created specifying only a check, it's ID
will contain an asterisk (or wildcard) in the `$SUBSCRIPTION` position. This
indicates that any event with a matching check name will be marked as silenced,
regardless of the originating client's subscriptions.

Conversely, a silencing entry which specifies only a subscription will have an
ID with an asterisk in the `$CHECK` position. This indicates that any event where
the originating client's subscriptions match the subscription specified in the
entry will be marked as silenced, regardless of the check name.

## Silencing entry specification

### Silencing entry attributes

`check`
: description
  : Name of check which the entry should match on
: required
  : true, unless `subscription` is provided
: type
  : String
: default
  : null
: example
  : ~~~ json
    { "check": "haproxy_status", "subscription": "load_balancer" }
    ~~~

`subscription`
: description
  : Name of subscription which the entry should match on
: required
  : true, unless `check` is provided
: type
  : String
: default
  : null
: example
  : ~~~ json
    { "subscription": "client:i-424242" }
    ~~~

`id`
: description
  : Read-only attribute generated from the intersection of subscription name and
  check name.
: required
  : false -- this value cannot be modified
: type
  : String
: default
  : N/A
: example
  : ~~~ shell
    $ curl -s -X GET localhost:4567/silenced | jq .
    [
      {
        "expire": -1,
        "expire_on_resolve": false,
        "creator": null,
        "reason": null,
        "check": "mysql_status",
        "subscription": "appserver",
        "id": "appserver:mysql_status"
      }
    ]
    ~~~

`expire`
: description
  : Number of seconds until this entry should be automatically deleted.
: required
  : false
: type
  : Integer
: default
  : -1
: example
  : ~~~ json
    { "expire": 3600, "check": "disk_utilization", "subscription": "client:i-424242" }
    ~~~

`expire_on_resolve`
: description
  : If the entry should be automatically deleted when a matching check begins
  returning OK status.
: required
  : false
: type
  : Boolean
: default
  : false
: example
  : ~~~ json
    { "expire_on_resolve": true, "check": "mysql_status" }
    ~~~

`creator`
: description
  : Person, application or other entity responsible for creating the entry.
: required
  : false
: type
  : String
: default
  : null
: example
  : ~~~ json
    {
      "creator": "Application Deploy Tool 5.0",
      "subscription": "appservers",
      "check": "app_status"
    }
    ~~~

`reason`
: description
  : Explanation or rationale for this entry being created.
: required
  : false
: type
  : String
: default
  : null
: example
  : ~~~ json
    {
      "creator": "patrick",
      "subscription": "client:darkstar",
      "reason": "brb, rebooting"
    }
    ~~~

## Examples

### Silence all checks on a specific client

Assume a Sensu client "i-424242" which we wish to silence any alerts on. We'll
do this by taking advantage of [per-client subscriptions][4]:

~~~ shell
$ curl -s -i -X POST \
-H 'Content-Type: application/json' \
-d '{"subscription": "client:i-424242"}' \
http://localhost:4567/silenced

HTTP/1.1 201 Created
~~~

The `HTTP/1.1 201 Created` response indicates our POST was successful, so we
should be able to use GET to see the resulting entry:

~~~ shell
curl -s -X GET localhost:4567/silenced | jq .
[
  {
    "expire": -1,
    "expire_on_resolve": false,
    "creator": null,
    "reason": null,
    "check": null,
    "subscription": "client:i-424242",
    "id": "client:i-424242:*"
  }
]
~~~

Now, imagine that we'd like to make this entry expire in 3600 seconds:

~~~ shell
$ curl -s -i -X POST \
-H 'Content-Type: application/json' \
-d '{"subscription": "client:i-424242", "expire": 3600 }' \
http://localhost:4567/silenced

HTTP/1.1 201 Created
~~~

If we query the list of silenced entries again, we can see the value of
`"expire"` has changed from -1 to a value which decrements as time passes:

~~~ shell
curl -s -X GET localhost:4567/silenced | jq .
[
  {
    "expire": 3557,
    "expire_on_resolve": false,
    "creator": null,
    "reason": null,
    "check": null,
    "subscription": "client:i-424242",
    "id": "client:i-424242:*"
  }
]
~~~

### Silence a specific check on a specific client

Following on the previous example, let's silence a check named "check_ntp" on
client "i-424242":

~~~ shell
$ curl -s -i -X POST \
-H 'Content-Type: application/json' \
-d '{"subscription": "client:i-424242", "check": "check_ntp"}'
http://localhost:4567/silenced

HTTP/1.1 201 Created
~~~

Now suppose I'd like to ensure this silencing entry is deleted once I've
resolved the underlying condition it is reporting on:

~~~ shell
$ curl -s -i -X POST \
-H 'Content-Type: application/json' \
-d '{"subscription": "client:i-424242", "check": "check_ntp", "expire_on_resolve": true}'
http://localhost:4567/silenced

HTTP/1.1 201 Created
~~~

The optional `expire_on_resolve` attribute used here indicates that when the
server processes a matching check from the specified client with status `OK`,
this silencing entry will automatically be removed from the registry.

When used in combination with other attributes (e.g. `creator` and `reason`),
this provides Sensu operators with way to acknowledge that they have received an
alert, suppressing additional notifications, and automatically clearing the
silencing entry when the check status returns to normal.

### Silence all checks on clients with a specific subscription

Assume a client subscription "appserver" which we wish to silence completely.
Just as with our example of silencing all checks on a specific client, we'll
create a silencing entry specifying only the applicable subscription:

~~~ shell
$ curl -s -i -X POST \
-H 'Content-Type: application/json' \
-d '{"subscription": "appserver"}'
http://localhost:4567/silenced

HTTP/1.1 201 Created
~~~

### Silence a specific check on clients with a specific subscription

Assume a check "mysql_status" which we wish to silence, running on Sensu
clients with the subscription "appserver":

~~~ shell
$ curl -s -i -X POST \
-H 'Content-Type: application/json' \
-d '{"subscription": "appserver", "check": "mysql_status"}' \
http://localhost:4567/silenced

HTTP/1.1 201 Created
~~~

The `HTTP/1.1 201 Created` response indicates our POST was successful, so we
should be able to use GET to see the resulting entry:

~~~ shell
$ curl -s -X GET localhost:4567/silenced | jq .
[
  {
    "expire": -1,
    "expire_on_resolve": false,
    "creator": null,
    "reason": null,
    "check": "mysql_status",
    "subscription": null,
    "id": "appserver:mysql_status"
  }
]
~~~

### Deleting (clearing) silencing entries

Assuming we know the ID of a silencing entry, we delete it by via HTTP POST as
well:

~~~ shell
$ curl -s -i -X POST \
-H 'Content-Type: application/json' \
-d '{"id": "appserver:mysql_status"}'
http://localhost:4567/silenced/clear

HTTP/1.1 204 No Content
~~~

In this case the `HTTP/1.1 204 No Content` response indicates our POST was
successful, meaning the silencing entry has been cleared (deleted) from the
`silenced` registry.

[1]: handlers.html
[2]: ../api/silenced-api.html
[3]: handlers.html#handler-attributes
[4]: clients.html#client-subscriptions