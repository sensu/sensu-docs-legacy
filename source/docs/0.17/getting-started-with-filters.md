---
version: 0.17
category: "Getting Started Guide"
title: "Getting Started with Filters"
next:
  url: "getting-started-with-mutators"
  text: "Getting Started with Mutators"
---

# Overview

The purpose of this guide is to help Sensu users create event filters. At the conclusion of this guide, you - the user - should have several Sensu event filters in place to filter events for one or more event handlers. Each Sensu filter in this guide demonstrates one or more filter definition features, for more information please refer to the [Sensu filters reference documentation](filters).

## Objectives

What will be covered in this guide:

- Creation of an event filter
- Creation of an event filter that uses an "eval" attribute value

# What are Sensu filters? {#what-are-sensu-filters}

Sensu filters allow you to filter (out) events destined for one or more event handlers. Sensu filters inspect event data and match its key/values with filter definition attributes, to determine if the event should be passed to an event handler. Filters are commonly used to filter event recurrences to eliminate notification noise and to filter events that are not for production machines.

# Create an event filter

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

To filter (negate) events that do have a custom client attribute `environment` with the value `production`, use the `negate` filter definition attribute.

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

To use the Sensu filter `production` for an event handler, use the `filter` handler definition attribute. For example:

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

A Sensu event handler may use multiple event filters, using the `filters` handler definition attribute. For example:

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

# Create an event filter with an "eval" attribute

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
