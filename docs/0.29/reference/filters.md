---
title: "Filters"
description: "Reference documentation for Sensu Filters."
version: 0.29
weight: 6
---

# Sensu Filters

## Reference documentation

- [What are Sensu Filters?](#what-are-sensu-filters)
  - [When to use a filter](#when-to-use-a-filter)
- [How do Sensu filters work?](#how-do-sensu-filters-work)
  - [Inclusive and exclusive filtering](#inclusive-and-exclusive-filtering)
  - [Filter attribute comparison](#filter-attribute-comparison)
  - [Filter attribute evaluation](#filter-attribute-evaluation)
- [Filter attribute eval tokens](#filter-attribute-eval-tokens)
  - [What are filter attribute eval tokens?](#what-are-filter-attribute-eval-tokens)
  - [Example filter attribute eval token](#example-filter-attribute-eval-token)
  - [Filter attribute eval token specification](#filter-attribute-eval-token-specification)
    - [Eval token interpolation](#eval-token-interpolation)
    - [Eval token default values](#eval-token-default-values)
- [Filter configuration](#filter-configuration)
  - [Filter definition specification](#filter-definition-specification)
    - [Filter naming](#filter-naming)
    - [Filter attributes](#filter-attributes)
    - [`when` attributes](#when-attributes)

## What are Sensu filters?

Sensu Filters (also called Event Filters) allow you to filter events destined
for one or more event [Handlers][1]. Sensu filters inspect event data and
match its keys/values with filter definition attributes, to determine if the
event should be passed to an event handler. Filters are commonly used to filter
recurring events (i.e. to eliminate notification noise) and to filter events
from systems in pre-production environments.

### When to use a filter

Sensu Filters allow you to configure conditional logic to be applied during the
event processing flow. Compared to executing an event handler, evaluating event
filters is an inexpensive operation which can provide overall monitoring
performance gains by reducing the  number of events that need to be handled.
Additionally, by using Sensu Filters, instead of building conditional logic into
custom Handlers, conditional logic can be applied to multiple Handlers, and
monitoring configuration stays <abbr title="Don't Repeat Yourself">DRY</abbr>.

## How do Sensu filters work?

Sensu Filters are applied when Event [Handlers][1] are configured to use one or
more Filters. Prior to executing a Handler, the Sensu server will apply any
Filters configured for the Handler to the Event Data. If the Event is not
removed by the Filter(s) (i.e. filtered out), the Handler will be executed. The
filter analysis flow performs these steps:

- When the Sensu server is processing an Event, it will check for the definition
  of a `handler` (or `handlers`). Prior to executing each Handler, the Sensu
  server will first apply any configured `filter` (or `filters`) for the Handler
- If multiple `filters` are configured for a Handler, they are executed
  sequentially
- Filter `attributes` are compared with Event data
- Filters can be inclusive (only matching events are handled) or exclusive
  (matching events are _not_ handled)
- As soon as a Filter removes an Event (i.e. filters it out), no further
  analysis is performed and the Event Handler will not be executed

_NOTE: Filters specified in a [handler set][16] definition have no effect.
Filters must be specified in individual handler definitions._

### Inclusive and Exclusive Filtering

Filters can be _inclusive_ (`"negate": false`) or _exclusive_  (`"negate":
true`). Configuring a handler to use multiple _inclusive_ `filters` is the
equivalent of using an `AND`  query operator (i.e. only handle events if they
match _inclusive_ filters  `x AND y AND z`). Configuring a handler to use
multiple _exclusive_ `filters` is the equivalent of using an `OR` operator (i.e.
only handle events if they don't match `x OR y OR z`).

- **Inclusive filtering**: by setting the [filter definition attribute][2]
  `"negate": false`, only events that match the defined filter attributes are
  handled.

- **Exclusive filtering**: by setting the [filter definition attribute][2]
  `"negate": true`, events are only handled if they do not match the defined
  filter attributes.

_NOTE: unless otherwise configured in the [filter definition][2], the default
filtering behavior is **inclusive filtering** (i.e. `"negate": false`)._

### Filter attribute comparison

Filter attributes are compared directly with their [event data][3] counterparts.
For [inclusive filter definitions][4] (i.e. `"negate": false`), matching
attributes will result in the filter returning a `true` value; for [exclusive
filter definitions][4] (i.e. `"negate": true`), matching attributes will result
in the filter returning a `false` value (i.e. the event does not pass through
the filter). Filters that return a true value will continue to be processed
&mdash; via additional filters (if defined), mutators (if defined), and
handlers.

#### EXAMPLE

The following example filter definition, entitled `production_filter` will match
[event data][3] with a [custom client definition attribute][5] `"environment":
"production"`.

~~~ json
{
  "filters": {
    "production_filter": {
      "negate": false,
      "attributes": {
        "client": {
          "environment": "production"
        }
      }
    }
  }
}
~~~

### Filter attribute evaluation

When more complex conditional logic is needed than [direct filter attribute
comparison][10], Sensu filters provide support for
attribute evaluation using Ruby expressions. When a Filter attribute value is a
string beginning with `eval:`, the remainder is evaluated as a Ruby expression.
The Ruby expression is evaluated in a "sandbox" and provided a single variable
(`value`) which is equal to the event data attribute value being compared. If
the evaluated expression returns true, the attribute is a match.

#### Example: Handling state change only

Some teams migrating to Sensu have asked about reproducing the behavior of their
old monitoring system which alerts only on state change. This
`state_change_only` [inclusive][4] filter provides such.

~~~ json
{
  "filters": {
    "state_change_only": {
      "negate": false,
      "attributes": {
        "occurrences": "eval: value == 1 || ':::action:::' == 'resolve'"
      }
    }
  }
}
~~~

This eval filter is effective because value of event `occurrences` is reset on each
state change, except when the event `action` is `:resolve`. The resolve action
is set on an event when its check result status is `0` following one or more prior
non-zero statuses.


#### Example: Handling repeated events

The following example filter definition, entitled `filter_interval_60_hourly`,
will match [event data][3] with a [check `interval`][6] of `60` seconds, _and_
an `occurrences` value of `1` (i.e. the first occurrence) _-OR-_ any
`occurrences` value that is evenly divisible by 60 (via a [modulo operator][7]
calculation; i.e. calculating the remainder after dividing `occurrences` by 60).

Note that negate is true, making this an [exclusive filter][4]; if evaluation
returns false, the event will be handled.

~~~ json
{
  "filters": {
    "filter_interval_60_hourly": {
      "negate": true,
      "attributes": {
        "check": {
          "interval": 60
        },
        "occurrences": "eval: value != 1 && value % 60 != 0"
      }
    }
  }
}
~~~

The next example will apply the same logic as the previous example, but for
checks with a 30 second `interval`.

~~~ json
{
  "filters": {
    "filter_interval_30_hourly": {
      "negate": true,
      "attributes": {
        "check": {
          "interval": 30
        },
        "occurrences": "eval: value != 1 && value % 120 != 0"
      }
    }
  }
}
~~~

_NOTE: The effect of both of these filters is that they will only allow an
events with 30-second or 60-second intervals to be [handled][1] on the first
occurrence of the event, and again every hour. Previous examples in the older
Sensu docs have not included the `"check": { "interval": 60 }` attribute, which
has confused some users because filtering based on occurrences alone assumes
some understanding of the relationship between `occurrences` and `interval`,
which isn't always obvious._

#### Example: Handling events during "office hours" only

This filter evaluates the event timestamp to determine if the event occurred
between 9 AM and 5 PM on a weekday. Remember that `negate` defaults to false, so
this is an inclusive filter. If evaluation returns false, the event will not be

~~~ json
{
  "filters": {
    "nine_to_fiver": {
      "negate": false,
      "attributes": {
        "timestamp": "eval: [1,2,3,4,5].include?(Time.at(value).wday) && Time.at(value).hour.between?(9,17)"
      }
    }
  }
}
~~~

## Filter attribute eval tokens

### What are filter attribute eval tokens?

Sensu filters attributes may be [evaluated using Ruby expressions][10], which
evaluations provide support for comparing a single event attribute variable
against a basic logical statement (e.g. is `value` greater than `60`?). When
additional variables are needed beyond the single `value` variable provided by
`eval:`, tokens may be used. Eval tokens are filter attribute placeholders that
can be replaced by [Sensu check definition attributes][6] and [client definition
attributes][8] (including custom attributes).

### Example filter attribute eval token

The following is an example Sensu [filter definition][2], which is using a
token (`:::check.occurrences|60:::`) as a secondary attribute in the Ruby eval
expression. The token will be replaced by the [check definition attribute][6]
named `occurrences` if it is defined, otherwise it will use the fallback value
of `60`.

~~~ json
{
  "filters": {
    "occurrences": {
      "negate": true,
      "attributes": {
        "occurrences": "eval: value > :::check.occurrences|60:::"
      }
    }
  }
}
~~~

This example would be useful for filtering events that don't exceed a minimum
number of `occurrences` as configured in the check definition.

### Filter attribute eval token specification

#### Eval token substitution syntax

Eval tokens are invoked by wrapping event data attributes with "triple colons"
(i.e. three colon characters before and after the attribute, i.e. `:::`). Nested
[event data attributes][3] may be accessed via "dot notation" (e.g.
`check.occurrences`)

- `:::occurrences:::` would be replaced with the [event `occurrences` data][11]
- `:::check.my_threshold:::` would be replaced with a [custom check definition
  attribute][12] called `my_threshold`

#### Eval token default values

Eval token default values can be used as a fallback in the event that an [eval
token attribute][13] is not satisfied by [event data][3]. Eval token default
values are separated by a pipe character (`|`), and can be used to provide a
"fallback value" for events that are missing the declared token attribute.

- `:::check.occurrences|60:::` would be replaced with a [check definition
  attribute][6] called `occurrences`. If `occurrences` is not defined in the
  check definition, the default (or fallback) value of `60` will be used.

_NOTE: if an eval token default value is not provided (i.e. as a fallback
value), and the event data does not contain a matching [eval token
attribute][13], an log entry indicating an error called `"filter eval unmatched
tokens"` will be published to the Sensu server log._

## Filter configuration

### Example filter definition {#example-filter-definition}

The following is an example Sensu filter definition, a JSON configuration file
located at `/etc/sensu/conf.d/filter_production.json`. This is an inclusive
filter definition called `production`. The effect of this filter is that only
events with the [custom client attribute][5] `"environment": "production"` will
be handled.

~~~ json
{
  "filters": {
    "production": {
      "attributes": {
        "client": {
          "environment": "production"
        }
      },
      "negate": false
    }
  }
}
~~~

### Filter definition specification

#### Filter naming

Each filter definition has a unique name, used for the definition key. Every
filter definition is within the `"filters": {}` definition scope.

- A unique string used to name/identify the filter
- Cannot contain special characters or spaces
- Validated with [Ruby regex][9] `/^[\w\.-]+$/.match("filter-name")`


#### Filter attributes

`negate`
: description
  : If the filter will negate events that match the filter attributes.
    _NOTE: see [Inclusive and exclusive filtering][4] for more information._
: required
  : false
: type
  : Boolean
: default
  : `false`
: example
  : ~~~ shell
    "negate": true
    ~~~

`attributes`
: description
  : Filter attributes to be compared with Event data.
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "attributes": {
      "check": {
        "team": "ops"
      }
    }
    ~~~

`when`
: description
  : The [`when` definition scope][14], used to determine when a
  filter is applied (time windows).
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "when": {
      "days": {
        "all": [
          {
            "begin": "5:00 PM",
            "end": "8:00 AM"
          }
        ]
      }
    }
    ~~~

#### `when` attributes

The following attributes are configured within the `{"filters": { "FILTER": {
"when": {} } } }` [configuration scope][14] (where `FILTER` is a valid [filter
name][15]).

##### EXAMPLE {#when-attributes-example}

~~~ json
{
  "filters": {
    "offhours": {
      "attributes": {
        "client": {
          "environment": "production"
        }
      },
      "when": {
        "days": {
          "all": [
            {
              "begin": "5:00 PM",
              "end": "8:00 AM"
            }
          ]
        }
      }
    }
  }
}
~~~

##### ATTRIBUTES {#when-attributes-specification}

`days`
: description
  : A hash of days of the week or 'all', each day specified defines
  one or more time windows in which the filter is applied.
: required
  : false (unless `when` is configured)
: type
  : Hash
: example
  : ~~~ shell
    "days": {
      "all": [
        {
          "begin": "5:00 PM",
          "end": "8:00 AM"
        }
      ],
      "friday": [
        {
          "begin": "12:00 PM",
          "end": "5:00 PM"
        }
      ]
    }
    ~~~

[1]:  handlers.html
[2]:  #filter-definition-specification
[3]:  events.html#event-data
[4]:  #inclusive-and-exclusive-filtering
[5]:  clients.html#custom-attributes
[6]:  checks.html#check-definition-specification
[7]:  https://en.wikipedia.org/wiki/Modulo_operation
[8]:  clients.html#client-definition-specification
[9]:  http://ruby-doc.org/core-2.2.0/Regexp.html
[10]: #filter-attribute-comparison
[11]: events.html#event-data-specification
[12]: checks.html#custom-attributes
[13]: #eval-token-interpolation
[14]: #when-attributes
[15]: #filter-naming
[16]: handlers.html#handler-sets
