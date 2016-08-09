---
title: "Built-in Filters"
version: 0.25
weight: 3
next:
  url: "built-in-mutators.html"
  text: "Enterprise Built-in Mutators"
---

**ENTERPRISE: Built-in filters are available for [Sensu Enterprise][0]
users only.**

# Built-in Filters

## Reference documentation

- [What are built-in filters?](#what-are-built-in-filters)
- [Using built-in filters](#using-built-in-filters)
- [Using multiple built-in filters](#using-multiple-built-in-filters)

## What are built-in filters?

Sensu Enterprise has several built-in event filters, used by many of the
third-party integrations, and made available to standard Sensu event handlers.
These enterprise filters can be used to combat alert fatigue.

## Built-in filters

Please refer to the reference documentation for each of the following built-in
filters for more information on how to use them:

- [`handle_when`](filters/handle-when.html)
- [`silence_stashes`](filters/silence-stashes.html)
- [`check_dependencies`](filters/check-dependencies.html)

### Using multiple built-in filters

Multiple enterprise filters can be applied to standard Sensu event handlers. The
following example event handler uses the `handle_when` and `silence_stashes`
event filters.

~~~ json
{
  "handlers": {
    "custom_mailer": {
      "type": "pipe",
      "command": "custom_mailer.rb",
      "filters": [
        "handle_when",
        "silence_stashes"
      ]
    }
  }
}
~~~

[0]:  /enterprise
