---
title: "Contact Routing"
version: 0.24
weight: 5
next:
  url: "api.html"
  text: "Enterprise API"
---

# Contact Routing

Every incident or outage has an ideal first responder, a team or individual with the knowledge to triage and address the issue. Sensu Enterprise contact routing makes it possible to assign checks to specific teams and/or individuals, reducing mean time to response and recovery, MTTR. Contact routing works with all of the Sensu Enterprise third-party integrations.

A contact is composed of a name and configuration for one or more integrations. Contact integration configuration is merged upon the global (top-level) configuration. The contact example below specifies an email address which overrides the address specified in the global integration configuration.

## Example contact routing configuration

~~~ json
{
  "email": {
    "smtp": {
      "address": "smtp.example.com",
      "port": 587
    },
    "to": "support@example.com",
    "from": "noreply@example.com"
  },
  "contacts": {
    "ops": {
      "email": {
        "to": "ops@example.com"
      }
    }
  }
}
~~~

To specify a contact for a check, the check definition attribute `contact` is used. When the defined check produces an event, the contact's integration configuration will be used, overriding the global integration configuration attributes.

~~~ json
{
  "checks": {
    "load_balancer_listeners": {
      "command": "check-haproxy.rb -s /var/run/haproxy.sock -A",
      "subscribers": [
        "load_balancer"
      ],
      "interval": 20,
      "handler": "email",
      "contact": "ops"
    }
  }
}
~~~

Multiple contacts can be specified for a check, using the check definition attribute `contacts`, providing an array of contacts.

~~~ json
{
  "checks": {
    "load_balancer_listeners": {
      "command": "check-haproxy.rb -s /var/run/haproxy.sock -A",
      "subscribers": [
        "load_balancer"
      ],
      "interval": 20,
      "handler": "email",
      "contacts": [
        "ops",
        "search"
      ]
    }
  }
}
~~~

### Definition attributes

contact
: description
  : A contact name to use for the check.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "contact": "ops"
    ~~~

contacts
: description
  : An array of contact names to use for the check. Each array item (name) must be a string.
: required
  : false
: type
  : Array
: example
  : ~~~ shell
    "contacts": ["ops"]
    ~~~
