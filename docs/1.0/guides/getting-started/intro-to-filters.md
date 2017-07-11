---
title: "Intro to Filters"
version: 1.0
weight: 5
next:
  url: "intro-to-mutators.html"
  text: "Getting Started with Mutators"
---

# Getting Started with Filters

The purpose of this guide is to help Sensu users create event filters. At the
conclusion of this guide, you - the user - should have several Sensu event
filters in place to filter events for one or more event handlers. Each Sensu
filter in this guide demonstrates one or more filter definition features, for
more information please refer to the [Sensu filters reference documentation][1].

## Objectives

What will be covered in this guide:

- Creation of an event filter
- Creation of an event filter with Ruby and math!

## What are Sensu filters? {#what-are-sensu-filters}

Sensu filters allow you to filter (out) events destined for one or more event
handlers. Sensu filters inspect event data and match its key/values pairs with
filter definition `attributes`, to determine if the event should be passed to an
event handler. Filters are commonly used to filter event recurrences to
eliminate notification noise and to filter events that are not for production
machines.

## Create an event filter

### Inclusive filtering

The following is an example Sensu filter definition, a JSON configuration file
located at `/etc/sensu/conf.d/filter_production.json`. This filter definition
will include events that match the filter criteria. In this example, the filter
itself is named `production` which matches events with a custom client attribute
entitled `environment` with the value `production`.

~~~ json
{
  "filters": {
    "production": {
      "attributes": {
        "client": {
          "environment": "production"
        }
      }
    }
  }
}
~~~

### Exclusive filtering

To exclude events based on filter criteria, set the `negate` filter definition
attribute to `true`. In this example, the `production` filter will match events
that **do not** have a custom client attribute entitled `environment` with the
value `production`.

~~~ json
{
  "filters": {
    "production": {
      "attributes": {
        "client": {
          "environment": "production"
        }
      },
      "negate": true
    }
  }
}
~~~

## Using a filter

To use the `production` filter for an event handler, set the `filter` attribute
in the handler definition. For example:

~~~ json
{
  "handlers": {
    "mail": {
      "type": "pipe",
      "command": "mailx -s 'sensu event' example@address.com",
      "filter": "production"
    }
  }
}
~~~

## Using multiple filters

To specify multiple Sensu event filters, use the `filters` attribute (plural).

_NOTE: if both `filter` and `filters` (plural) handler definition attributes are
used, `filters` will take precedence._

~~~ json
{
  "handlers": {
    "mail": {
      "type": "pipe",
      "command": "mailx -s 'sensu event' example@address.com",
      "filters": [
        "production",
        "operations"
      ]
    }
  }
}
~~~

## Create an event filter with Ruby and math!

Filter `attributes` are compared directly with their event data counterparts via
Ruby object comparison. However, it is also possible to use Ruby expressions to
evaluate event data attribute values. When a filter attribute value is a string
that begins with `eval:`, the remainder of the string is evaluated as a Ruby
expression. The event data attribute value is provided to the Ruby expression as
a variable entitled `value`. If the evaluated expression returns `true`, the
attribute is a match. This Ruby expression evaluation is performed in a
"sandbox" (for safety).

The following is an example Sensu filter definition, a JSON configuration file
located at `/etc/sensu/conf.d/filter_recurrences.json`. This filter excludes
events that are not the first event occurrence _and_ those that do not have an
occurrence count divisible by 60 without a remainder (recurrence). Logically, if
checks with an execution interval of 1 minute are generating events every
minute, this filter will help "reduce noise" by only allowing event handling
once per hour.

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

[1]:  ../reference/filters.html
