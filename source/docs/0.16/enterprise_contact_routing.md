---
version: "0.16"
category: "Enterprise"
title: "Enterprise contact routing"
next:
  url: enterprise_transports
  text: "Enterprise transports"
---

# Enterprise contact routing

Every incident or outage has an ideal first responder, a team or
individual with the knowledge to triage and address the issue. Sensu
Enterprise contact routing makes it possible to assign checks to
specific teams and/or individuals, reducing mean time to response and
recovery, MTTR. Contact routing works with all of the Sensu Enterprise
third-party integrations.

A contact is composed of a name and configuration for one or more
integrations. Contact integration configuration is merged upon the
top-level configuration. The contact example below specifies an email
address which override the address specified in the top-level integration
configuration.

~~~ json
{
    "email": {
        "smtp": {
            "address": "smtp.example.com",
            "port": 587,
        },
        "to": "support@example.com",
        "from": "noreply@example.com"
    }
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

You may also configure multiple contacts for a check, using the
configuration key `contacts`, providing an array of contacts.

~~~ json
{
    "checks": {
        "test": {
            "command": "true",
            "subscribers": [
                "test"
            ],
            "interval": 10,
            "contacts": [
                "ops",
                "search"
            ]
        }
    }
}
~~~
