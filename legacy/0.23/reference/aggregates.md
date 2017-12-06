---
title: "Aggregates"
version: 0.23
weight: 4
---

# Sensu Check Aggregates

## Reference documentation

- [What is a Sensu check aggregate?](#what-is-a-check-aggregate)
  - [When should check aggregates be used?](#when-should-check-aggregates-be-used)
- [How do check aggregates work?](#how-do-check-aggregates-work)
  - [Example aggregated check result](#example-aggregated-check-result)
- [Aggregate configuration](#aggregate-configuration)
  - [Example aggregate definition](#example-aggregate-definition)
  - [Aggregate definition specification](#aggregate-definition-specification)
    - [Aggregate `check` attributes](#aggregate-check-attributes)

## What is a Sensu check aggregate?

Sensu check aggregates are collections of [check results][1] for a single
[subscription check][2] request, made available via the [Aggregates API][3].
Check aggregates make it possible to treat the results of a subscription check
request &ndash; executed on multiple disparate systems &ndash; as a single
result.

### When should check aggregates be used?

Check aggregates are extremely useful in dynamic environments and/or
environments that have a reasonable tolerance for failure. Check aggregates
should be used when a service can be considered healthy as long as a minimum
threshold is satisfied (e.g. are at least 5 healthy web servers? are at least
70% of N processes healthy?).

## How do check aggregates work?

Check results are included in an aggregate when a check is configure to use the
[`"aggregate": true` check definition attribute][5]. Check results with
`"aggregate": true` are aggregated per check `name` and `issued` timestamp,
effectively capturing the results (plural) of a single [check request][9] as a
single aggregate.

### Example aggregated check result

Aggregated check results are available from the [Aggregates API][3], via the
`/aggregates/:check/:issued` API endpoint. An aggregate check result provides a
set of counters indicating the total number of results collected, with a
breakdown of how many results were recorded per status (i.e. `ok`, `warning`,
`critical`, and `unknown`).

~~~ json
{
  "total": 5,
  "unknown": 0,
  "critical": 0,
  "warning": 1,
  "ok": 4
}
~~~

## Aggregate configuration

### Example aggregate definition

The following is an example [check definition][6], a JSON configuration file
located at `/etc/sensu/conf.d/check_aggregate_example.json`.

~~~
{
  "checks": {
    "example_check_aggregate": {
      "command": "do_something.rb -o option",
      "aggregate": true,
      "handle": false
    }
  }
}
~~~

### Aggregate definition specification

_NOTE: aggregates are created via the `"aggregate": true` [Sensu `check`
definition attribute][4]. The configuration example(s) provided above, and the
"specification" provided here are for clarification and convenience only (i.e.
this "specification" is just a subset of the [check definition
specification][5], and not a definition of a distinct Sensu primitive)._

#### Aggregate `check` attributes

`aggregate`
: description
  : Create a result aggregate for the check. Check result data will be
    aggregated and exposed via the [Sensu Aggregates API][3].
    _NOTE: this feature is currently not supported with [standalone checks][7]._
: required
  : false
: type
  : Boolean
: default
  : false
: example
  : ~~~ shell
    "aggregate": true
    ~~~

`handle`
: description
  : If events created by the check should be handled.
: required
  : false
: type
  : Boolean
: default
  : true
: example
  : ~~~ shell
    "handle": false
    ~~~
    _NOTE: although there are cases when it may be helpful to aggregate check
    results **and** handle individual check results, it is typically recommended
    to set `"handle": false` when aggregating check results, as the [purpose of
    the aggregation][8] should be to act on the state of the aggregated
    result(s) rather than the individual check result(s)._

[1]:  checks.html#check-results
[2]:  checks.html#subscription-checks
[3]:  ../api/aggregates-api.html
[4]:  checks.html#check-attributes
[5]:  checks.html#check-definition-specification
[6]:  checks.html#check-configuration
[7]:  checks.html#standalone-checks
[8]:  #when-should-check-aggregates-be-used
[9]:  checks.html#how-are-checks-scheduled
