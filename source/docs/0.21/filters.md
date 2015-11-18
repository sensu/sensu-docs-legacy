---
version: 0.21
category: "Reference Docs"
title: "Filters"
next:
  url: "mutators"
  text: "Mutators"
---

# Overview

This reference document provides information to help you:

- Understand what a Sensu filter is
- How a Sensu filter works
- Write a Sensu filter definition
- Use filter definition attributes

# What are Sensu filters? {#what-are-sensu-filters}

Sensu filters allow you to filter (out) events destined for one or more event handlers. Sensu filters inspect event data and match its key/values with filter definition attributes, to determine if the event should be passed to an event handler. Filters are commonly used to filter event recurrences to eliminate notification noise and to filter events that are not for production machines.

# Filter definition

A Sensu filter definition is a JSON configuration file describing a Sensu filter. A definition declares how a Sensu filter determines if an event is filtered for an event handler:

- The filter attributes to be compared with event data
- If the event is to be negated when filter attributes match

## Example filter definition {#example-filter-definition}

The following is an example Sensu filter definition, a JSON configuration file located at `/etc/sensu/conf.d/filter_production.json`. This filter definition filters (negates) events that do not have a custom client attribute `environment` with the value `production`. The filter is named `production`.

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

# Anatomy of a filter definition

### Name

Each filter definition has a unique check name, used for the definition key. Every filter definition is within the `"filters": {}` definition scope.

- A unique string used to name/identify the filter
- Cannot contain special characters or spaces
- Validated with `/^[\w\.-]+$/`
- e.g. `"production": {}`

### Definition attributes

negate
: description
  : If the filter will negate events that match the filter attributes.
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
  : Filter attributes to be compared with event data.
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

# Filter eval attributes

Filter attributes are compared directly with their event data counterparts, with the exception of eval attribute values. When a filter attribute value is a string, beginning with `eval:`, the remainder is evaluated as a Ruby expression. The Ruby expression is evaluated in a "sandbox" and provided a single variable, `value`, equal to the event data attribute value being compared. If the evaluated expression returns `true`, the attribute is a match.

The following is an example Sensu filter definition, a JSON configuration file located at `/etc/sensu/conf.d/filter_recurrences.json`. This filter negates events that are not the first occurrence and those that do not have an occurrence count divisible by 60 without a remainder (recurrence).

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
