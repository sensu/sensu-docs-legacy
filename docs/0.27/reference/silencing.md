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
- [How does silencing work?](#how-does-silencing-work)
- [Silencing entry specification](#silencing-entry-specification)
  - [Silencing entry attributes](#silencing-entry-attributes)
- [Examples](#examples)
  - [Silence all checks on a specific client](#silence-all-checks-on-a-specific-client)
  - [Silence a specific check on a specific client](#silence-a-specific-check-on-a-specific-client)
  - [Silence all checks on clients with a specific subscription](#silence-all-checks-on-clients-with-a-specific-subscription)
  - [Silence a specific check on clients with a specific subscription](#silence-a-specific-check-on-clients-with-a-specific-subscription)
  - [Silence a specific check on every client regardless of subscriptions](#silence-a-specific-check-on-every-client)
  - [Deleting silencing entries](#deleting-silencing-entries)
- [Appendix: Deprecated stash-based silencing](#appendix-deprecated-stash-based-silencing)
  - [Comparing stash-based and native silencing](#comparing-stash-based-and-native-silencing)
  - [Migrating from stash-based silencing](#migrating-from-stash-based-silencing)

## What is Sensu Silencing?

As [check results][0] are processed by a Sensu server, the server executes [event
handlers][1] to send alerts to personnel or otherwise relay event data to external
services. Although event handlers can be directly configured with [filters][11]
to improve overall signal-to-noise ratio, there are many scenarios in which
operators receiving notifications from Sensu require an on-demand means to
suppress alerts. Sensu's built-in silencing provides the means to suppress
execution of event handlers on an ad-hoc basis. By using a dashboard or other
tool to interact with the [`/silenced` API][2], operators can mute notifications
on-the-fly.

The /silenced API manipulates silencing entries in the Sensu data store. These
entries describe a combination of check name and subscription. When the [check
name][3] and/or [subscription][4] described in a silencing entry match an event,
the handler will not be executed and an informational message will be logged.
Individual handlers may opt-out of silencing by configuring the
[`handle_silenced` attribute][5].

_NOTE: Silencing described in this reference document is implemented in Sensu
version 0.26 or later and Sensu Enterprise 2.0 or later._

### When to use silencing

Silencing is used to prevent handlers from being triggered based on the check
name present in a check result or the subscriptions associated with the client
that published the check result. This can be desirable in many scenarios, giving
operators the ability to quiet incoming alerts while coordinating their response.

Sensu silencing entries make it possible to:

* [Silence all checks on a specific client](#silence-all-checks-on-a-specific-client)
* [Silence a specific check on a specific client](#silence-a-specific-check-on-a-specific-client)
* [Silence all checks on clients with a specific subscription](#silence-all-checks-on-clients-with-a-specific-subscription)
* [Silence a specific check on clients with a specific subscription](#silence-a-specific-check-on-clients-with-a-specific-subscription)
* [Silence a specific check on every client regardless of subscriptions](#silence-a-specific-check-on-every-client)

In addition to the above combinations, silencing entries support:

* Expiration after a specified number of seconds
* Expiration after check returns to OK state (resolves)
* Describing the "reason" or rationale
* Describing the "creator" or entity responsible for an entry

## How does silencing work?

Silencing entries are created on an ad-hoc basis via the [`/silenced` API][2]
endpoint. When silencing entries are successfully created via the API, they
are assigned an ID in the format `$SUBSCRIPTION:$CHECK`, where `$SUBSCRIPTION`
is the name of a Sensu client subscription and `$CHECK` is the name of a Sensu
check. Silencing entries can be used to silence checks on specific clients by
by taking advantage of [per-client subscriptions][4] added in Sensu 0.26, e.g.
`client:$CLIENT_NAME`.

These silencing entries are persisted to the `silenced` registry in the [Sensu
data store][10]. When the Sensu server processes subsequent check results, it
consults this registry to determine whether or not a matching silencing entry
exists. If one or more matching entries exist in the registry, the event context
for the check result is updated to indicate that the event is silenced and the
ID of the entries which the check result matched.

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

_NOTE: Starting with version 0.26, Sensu clients automatically add a
subscription containing their client name prefixed with the string `client:`.
For example, client `i-424242` will automatically add subscription
`client:i-424242`. Silencing checks at the individual client level requires
clients to run Sensu 0.26+, or be manually configured with a `client:`
subscription._

## Silencing entry specification

Silencing entries are composed as a JSON document containing at least one of the
required `subscription` or `check` attributes, and additional optional
attributes as desired. Silencing entries are created, updated and deleted by
submitting JSON documents to endpoints on the [`/silenced` API][2] via HTTP POST
as shown in the examples below.

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
    {
      "check": "haproxy_status"
    }
    ~~~
: example
  : ~~~ json
    {
      "check": "haproxy_status",
      "subscription": "load_balancer"
    }
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
    {
      "subscription": "client:i-424242"
    }
    ~~~
: example
  : ~~~ json
    {
      "subscription": "client:i-424242",
      "check": "haproxy_status"
    }
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
    $ curl -s -X GET 127.0.0.1:4567/silenced | jq .
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
    {
      "expire": 3600,
      "check": "disk_utilization",
      "subscription": "client:i-424242"
    }
    ~~~

`expire_on_resolve`
: description
  : If the entry should be automatically deleted when a matching check begins
  returning OK status (resolves).
: required
  : false
: type
  : Boolean
: default
  : false
: example
  : ~~~ json
    {
      "expire_on_resolve": true,
      "check": "mysql_status"
    }
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
http://127.0.0.1:4567/silenced

HTTP/1.1 201 Created
~~~

The `HTTP/1.1 201 Created` response indicates our POST was successful, so we
should be able to use GET to see the resulting entry:

~~~ shell
curl -s -X GET 127.0.0.1:4567/silenced | jq .
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
http://127.0.0.1:4567/silenced

HTTP/1.1 201 Created
~~~

If we query the list of silenced entries again, we can see the value of
`"expire"` has changed from -1 to a value which decrements as time passes:

~~~ shell
curl -s -X GET 127.0.0.1:4567/silenced | jq .
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
-d '{"subscription": "client:i-424242", "check": "check_ntp"}' \
http://127.0.0.1:4567/silenced

HTTP/1.1 201 Created
~~~

Now suppose I'd like to ensure this silencing entry is deleted once I've
resolved the underlying condition it is reporting on:

~~~ shell
$ curl -s -i -X POST \
-H 'Content-Type: application/json' \
-d '{"subscription": "client:i-424242", "check": "check_ntp", "expire_on_resolve": true}' \
http://127.0.0.1:4567/silenced

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
-d '{"subscription": "appserver"}' \
http://127.0.0.1:4567/silenced

HTTP/1.1 201 Created
~~~

### Silence a specific check on clients with a specific subscription

Assume a check "mysql_status" which we wish to silence, running on Sensu
clients with the subscription "appserver":

~~~ shell
$ curl -s -i -X POST \
-H 'Content-Type: application/json' \
-d '{"subscription": "appserver", "check": "mysql_status"}' \
http://127.0.0.1:4567/silenced

HTTP/1.1 201 Created
~~~

The `HTTP/1.1 201 Created` response indicates our POST was successful, so we
should be able to use GET to see the resulting entry:

~~~ shell
$ curl -s -X GET 127.0.0.1:4567/silenced | jq .
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

### Silence a specific check on every client

Assume we'd like to silence the "mysql_status" check on every client in our
infrastructure, regardless of their subscriptions:

~~~ shell
$ curl -s -i -X POST \
-H 'Content-Type: application/json' \
-d '{"check": "mysql_status"}' \
http://127.0.0.1:4567/silenced

HTTP/1.1 201 Created
~~~

The `HTTP/1.1 201 Created` response indicates our POST was successful, so we
should be able to use GET to see the resulting entry:

~~~ shell
$ curl -s -X GET 127.0.0.1:4567/silenced | jq .
[
  {
    "expire": -1,
    "expire_on_resolve": false,
    "creator": null,
    "reason": null,
    "check": "mysql_status",
    "subscription": null,
    "id": "*:mysql_status"
  }
]
~~~

### Deleting silencing entries

Assuming we know the ID of a silencing entry, we can delete or clear it by via
HTTP POST on the `/silenced/clear` endpoint:

~~~ shell
$ curl -s -i -X POST \
-H 'Content-Type: application/json' \
-d '{"id": "appserver:mysql_status"}' \
http://127.0.0.1:4567/silenced/clear

HTTP/1.1 204 No Content
~~~

In this case the `HTTP/1.1 204 No Content` response indicates our POST was
successful, meaning the silencing entry has been cleared (deleted) from the
`silenced` registry.

## Appendix: Deprecated stash-based silencing

### Comparing stash-based and native silencing

Prior to Sensu 0.26 the ability to silence notifications was implemented in
external libraries like [sensu-plugin][6], using specially crafted Sensu API
[stashes][7].


Although silencing via stashes has not yet been removed from sensu-plugin, it is
deprecated by both the native silencing described in this document, and
[planned][8] [changes][9] in sensu-plugin itself.

Sensu's new built-in or "native" silencing offers the following advantages over
the stash-based silencing model which preceded it:

* Works for any type of handler (e.g. pipe, TCP, transport) or Sensu Enterprise integration.
* Works for any pipe handler regardless of language; no dependency on sensu-plugin
or similar libraries.
* Handlers can opt out of silencing via configuration ([see `handle_silenced` attribute][5].).
* Silencing can be applied to clients not yet registered with the system by
targeting subscriptions instead of client names.
* Silencing entries can be automatically removed once the corresponding check
returns OK
* Lower overhead - does not require forking a handler process to access the API

### Migrating from stash-based silencing

For most operators, a browser-based dashboard like Uchiwa or the Sensu
Enterprise Dashboard is the primary interface for silencing notifications on an
ad-hoc basis. As of Uchiwa 0.18 and Sensu Enterprise Console 2.0, these
dashboards now use the `/silenced` API in lieu of the `/stashes` API.

Even after upgrading both Sensu and the dashboard to take advantage of the /silenced
API, handler plugins will continue to query the `/stashes` API and honor stashes
under the `silence` path.

As a result, we recommend the following steps as part of any migration effort:

* Sensu Client should be upgraded so that clients will add `client:$CLIENT_NAME`
to their subscriptions.
  _NOTE: The `client:$CLIENT_NAME` subscription is required for native silencing
  to work at the individual client level._
* Sensu API and Server should be updated prior to upgrading Uchiwa or Sensu
Enterprise Console.
* Any existing entries under `/stashes/silence` should be recreated via the
`/silenced` API prior to upgrading Uchiwa or Sensu Enterprise Console.
* Any custom tooling which uses the `/stashes/silence` pattern should be updated
to use the new `/silenced` API.
* All entries in `/stashes/silence` be deleted via the `/stashes` API before
upgrading Uchiwa 0.18+ or Sensu Enterprise Console 2.0+.

[0]: checks.html#check-results
[1]: handlers.html
[2]: ../api/silenced-api.html
[3]: checks.html
[4]: clients.html#client-subscriptions
[5]: handlers.html#handler-attributes
[6]: http://github.com/sensu-plugins/sensu-plugin
[7]: stashes.html
[8]: https://github.com/sensu-plugins/sensu-plugin/issues/134
[9]: https://sensuapp.org/blog/2016/07/07/sensu-plugin-filter-deprecation.html
[10]: data-store.html
[11]: filters.html
