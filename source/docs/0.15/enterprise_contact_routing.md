---
version: "0.15"
category: "Enterprise"
title: "Contact routing"
next:
  url: enterprise_transports
  text: "Enterprise transports"
---

# Contact routing

Contact routing makes it possible to assign service and/or metrics
checks to an individual or group contact. Individual and group
contacts can have a series of contact details, leveraging any number
of the third-party integrations.

A contact is composed of a name and configuration for one or more
integrations. Contact integration configuration is merged upon the
global configuration. The contact example below specifies an email
address which override the address specified in the global integration
configuration.

~~~ json
{
    "contacts": {
        "ops": {
            "email": {
                "to": "ops@example.com"
            }
        }
    }
}
~~~

To specify a contact for a check, use the configuration key `contact`
in check definition. When the defined check produces an event, the
contact's integration configuration will be used.

~~~ json
{
    "checks": {
        "test": {
            "command": "true",
            "subscribers": [
                "test"
            ],
            "interval": 10,
            "contact": "ops"
        }
    }
}
~~~
