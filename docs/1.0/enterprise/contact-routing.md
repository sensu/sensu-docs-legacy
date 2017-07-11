---
title: "Contact Routing"
version: 1.0
weight: 5
next:
  url: "built-in-handlers.html"
  text: "Built-in Handlers (Integrations)"
---

# Contact Routing

## Reference documentation

- [What is contact routing?](#what-is-contact-routing)
- [How does contact routing work?](#how-does-contact-routing-work)
- [Contact Routing configuration](#contact-routing-configuration)
  - [Example Contact Routing definition](#example-contact-routing-definition)
  - [Contact Routing definition specification](#contact-routing-definition-specification)
    - [`CONTACT` attributes](#contact-attributes)

## What is contact routing?

Every incident or outage has an ideal first responder, a team or individual with
the knowledge to triage and address the issue. Sensu Enterprise contact routing
makes it possible to assign checks to specific teams and/or individuals,
reducing mean time to response and recovery (MTTR). Contact routing works with
all of the Sensu Enterprise third-party notification integrations.

## How does contact routing work?

Sensu Enterprise contacts are defined in JSON configuration files, which we
recommend to store in the `/etc/sensu/conf.d/contacts/` directory. A contact is
composed of a name and configuration overrides for one or more of Sensu
Enterprise's built-in integrations. A contact in Sensu Enterprise is not too
dissimilar from a contact on your phone, which usually have a name and one or
more _identifiers_ for various communication **channels** (e.g. a **phone**
_number_, **email** _address_, **Twitter** _username_, etc).

The following example contact definition provides overrides for the Sensu
Enterprise email and Slack integration default configuration settings.

~~~ json
{
  "contacts": {
    "support": {
      "email": {
        "to": "support@sensuapp.com"
      },
      "slack": {
        "channel": "#support"
      }
    }
  }
}
~~~

Once defined, Sensu Enterprise contacts are used the same way in which you use
contacts on your phone &ndash; by selecting a communication channel (e.g.
phone call, SMS, email, etc) &ndash; and then selecting the contact. With
Sensu Enterprise contact routing, the communication channels are [built-in
handlers (integrations)][1], and the selection of which channel to use is
managed by a check definition (or client definition).

The following example check definition will use the built-in Sensu Enterprise
email integration (event handler), notifying the `support` contact for any
corresponding events.

~~~ json
{
  "checks": {
    "example_check": {
      "command": "do_something.rb",
      "interval": 30,
      "handler": "email",
      "contact": "support"
    }
  }
}
~~~

## Contact routing configuration

### Example contact routing definition

The following is an example contact routing definition (i.e. a "contact"), a
JSON configuration file located at `/etc/sensu/conf.d/contacts/ops.json`.

~~~ json
{
  "contacts": {
    "support": {
      "pagerduty": {
        "service_key": "r3FPuDvNOTEDyQYCc7trBkymIFcy2NkE"
      },
      "slack": {
        "channel": "#support",
        "username": "sensu"
      }
    }
  }
}
~~~

### Contact Routing definition specification

#### Contact names

Each contact routing definition has a unique contact name, used for the
definition key. All contacts must be defined within the `"contacts": {}`
[configuration scope][2], and comply with the following requirements:

- A unique string used to name/identify the check
- Cannot contain special characters or spaces
- Validated with [Ruby regex][3] `/^[\w\.-]+$/.match("check-name")`

#### `CONTACT` attributes

Contact routing attributes are configured within the `{ "contacts": { "CONTACT":
{} } }` configuration scope (where `CONTACT` is a valid [contact name][3]).
Contact definition attributes are configuration overrides for built-in
integrations (e.g. [Email][4], [Slack][5], [PagerDuty][6], [ServiceNow][7] etc;
see the [built-in handlers reference documentation][1] for a complete listing).

##### EXAMPLES {#contact-attributes-examples}

In most cases, contact definitions are used to provide partial integration
handler attribute overrides. The following example only provides a `"to"`
(recipient) attribute to override the default email integration configuration:

~~~ json
{
  "contacts": {
    "support": {
      "email": {
        "to": "support@example.com"
      }
    }
  }
}
~~~

However, contact definitions are not limited to providing a single attribute
&mdash; they can be used to provide multiple attributes or even complete
integration handler definitions (potentially overriding the entire default
definition). For example, a contact could be used to provide an email
integration definition to use an alternate SMTP server from the default
configuration:

~~~ json
{
  "contacts": {
    "support": {
      "email": {
        "smtp": {
          "address": "smtp.support.example.com",
          "port": 587,
          "openssl_verify_mode": "none",
          "enable_starttls_auto": true,
          "authentication": "plain",
          "user_name": "postmaster@support.example.com",
          "password": "SECRET"
        },
        "to": "support@support.example.com",
        "from": "noreply@support.example.com"
      }
    }
  }
}
~~~

[?]:  #
[1]:  built-in-handlers.html
[2]:  ../reference/configuration.html#configuration-scopes
[3]:  #contact-names
[4]:  integrations/email.html
[5]:  integrations/slack.html
[6]:  integrations/pagerduty.html
[7]:  integrations/servicenow.html
