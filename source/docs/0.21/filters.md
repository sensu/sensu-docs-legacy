---
version: 0.21
category: "Reference Docs"
title: "Filters"
next:
  url: "mutators"
  text: "Mutators"
---

# Filters

This reference document provides information to help you:

- [Understand what a Sensu Filter is](#what-are-sensu-filters)
- [How a Sensu Filter works](#how-do-filters-work)
- [When you should use Filters](#when-should-i-use-a-filter)
- [Write a Filter definition](#example-filter-definition)
- [Use filter definition attributes](#definition-attributes)
- [Understand how to perform inclusive and exclusive filtering](#inclusive-and-exclusive-filtering)
- [Understand how to use attribute evaluation](#filter-attribute-evaluation)

## What are Sensu filters? {#what-are-sensu-filters}

Sensu Filters (also called Event Filters) allow you to filter events destined
for one or more event [Handlers](handlers). Sensu filters inspect event data and
match its keys/values with filter definition attributes, to determine if the
event should be passed to an event handler. Filters are commonly used to filter
recurring events (i.e. to eliminate notification noise) and to filter events
from systems in pre-production environments.

## How do Filters work? {#how-do-filters-work}

Sensu Filters are applied when Event [Handlers](handlers) are configured to use
one or more Filters. Prior to executing the Handler, the Sensu server will apply
any Filters configured for the Handler to the Event Data. If the Event is not
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
  analysis is performed (e.g. if multiple `filters` are configured), and the
  Event Handler will not be executed

## When should I use a Filter? {#when-should-i-use-a-filter}

Sensu Filters allow you to configure conditional logic to be applied during the
event processing cycle. Compared to executing an event handler, evaluating event
filters is an inexpensive operation which can provide overall monitoring
performance gains by reducing the overall number of events that need to be
handled. Additionally, by using Sensu Filters instead of building conditional
logic into custom Handlers, conditional logic can be applied to multiple
Handlers, and monitoring configuration stays <abbr title="Don't Repeat
Yourself">DRY</abbr>.

## Filter definition

A Sensu filter definition is a JSON configuration file describing a Sensu
Filter. A Filter definition declares how a Sensu Filter is applied to an Event
to determine if an Event should be handled or not.

### Example filter definition {#example-filter-definition}

The following is an example Sensu filter definition, a JSON configuration file
located at `/etc/sensu/conf.d/filter_production.json`. This is an inclusive
filter definition called `production`. The effect of this filter is that only
events with the [custom client attribute][client-custom-attributes]
`"environment": "production"` will be handled.

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

## Anatomy of a filter definition {#anatomy-of-a-filter-definition}

### Filter naming

Each filter definition has a unique name, used for the definition key. Every
filter definition is within the `"filters": {}` definition scope.

- A unique string used to name/identify the filter
- Cannot contain special characters or spaces
- Validated with `/^[\w\.-]+$/`
- e.g. `"production": {}`

### Definition attributes {#definition-attributes}

negate
: description
  : If the filter will negate events that match the filter attributes.
    _NOTE: see [Inclusive and exclusive
    filtering](#inclusive-and-exclusive-filtering) for more information._
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

attributes
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

## Inclusive and Exclusive Filtering {#inclusive-and-exclusive-filtering}

Filters can be _inclusive_ (i.e. `"negate": false`; only Events that match are
handled) or _exclusive_ (i.e. `"negate": true`; events are not handled if they
match). Configuring a Handler to use multiple _inclusive_ `filters` (`"negate":
false`) is the equivalent of using an `AND` query operator (i.e. only handle
events if they match _inclusive_ filter `x AND y AND z`). Configuring a Handler
to use multiple _exclusive_ `filters` (`"negate": true`) is the equivalent of
using an `OR` operator (i.e. only handle events if they don't match `x OR y OR
z`).

## Filter attributes evaluation {#filter-attribute-evaluation}

Filter `attributes` are compared directly with their Event data counterparts
(e.g. `"attributes: {"environment": "production"}"` is looking for exact matches
to a custom attribute called `environment` with the value `production`).
However, if (or _when_) more complex conditional logic is needed, Sensu Filters
provide support for attribute evaluation using Ruby expressions.

When a Filter `attribute` value is a string beginning with `eval:`, the
remainder is evaluated as a Ruby expression. The Ruby expression is evaluated in
a "sandbox" and provided a single variable, `value`, equal to the event data
attribute value being compared. If the evaluated expression returns `true`, the
attribute is a match.

### Example filter attribute evaluation

The following is an example Sensu Filter definition, a JSON configuration file
located at `/etc/sensu/conf.d/filter_recurrences.json`. This is an inclusive
filter definition called `recurrences`. The effect of this filter is that the
Handler this Filter is applied to will only be executed on the first occurrence
of an Event, and every subsequent occurrence that is divisible by 60 (i.e. every
60th occurrence).

~~~ json
{
  "filters": {
    "recurrences": {
      "attributes": {
        "occurrences": "eval: value == 1 || value % 60 == 0"
      }
    }
  }
}
~~~

[client-custom-attributes]:     clients#custom-definition-attributes
