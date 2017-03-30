---
title: "Role Based Access Controls"
version: 0.28
weight: 1
next:
  url: "rbac-for-ldap.html"
  text: "RBAC for LDAP"
---

**ENTERPRISE: Role based access controls are available for [Sensu Enterprise][0]
users only.**

# Role Based Access Controls

## Reference Documentation

- [What are Role Based Access Controls for Sensu Enterprise?](#what-are-role-based-access-controls)
  - [How does Sensu provide RBAC?](#how-does-sensu-provide-rbac)
  - [Supported RBAC drivers](#supported-rbac-drivers)
- [RBAC for the Sensu Enterprise Console API](#rbac-for-the-sensu-enterprise-console-api)
- [RBAC configuration](#rbac-configuration)
  - [Example RBAC definition](#example-rbac-definition)
  - [RBAC definition specification](#rbac-definition-specification)
    - [`DRIVER` attributes](#driver-attributes)
    - [`roles` attributes](#roles-attributes)
    - [`methods` attributes](#methods-attributes)

## What are Role Based Access Controls for Sensu Enterprise? {#what-are-role-based-access-controls}

Role-based access controls (RBAC) are a system for restricting access to
authorized users according to a role, or job function. RBAC for Sensu Enterprise
enables administrators to grant the correct level access to many different
development and operations teams, without requiring them to maintain yet another
user registry.

### How does Sensu provide RBAC?

The Sensu Enterprise Dashboard provides comprehensive and granular Role-Based
Access Controls (RBAC), with support for using a Lightweight Access Directory
Provider (LDAP), [GitHub.com][1], [GitHub Enterprise][2], and/or [GitLab][3] for
authentication. Roles can be defined to grant or restrict access to
monitoring data based on [datacenters][4], [Sensu subscriptions][5], and even
specific API endpoints (see the [Enterprise API reference documentation][6] for
more information).

### Supported RBAC drivers

Sensu Enterprise currently includes the following authentication drivers for
RBAC:

* [LDAP](rbac-for-ldap.html)
* [GitHub](rbac-for-github.html)
* [GitLab](rbac-for-gitlab.html)
* [OIDC](rbac-for-oidc.html)

## RBAC for the Sensu Enterprise Console API

As of Sensu Enterprise Dashboard version 1.12, RBAC configurations may be
applied to the [Sensu Enterprise Console API][14]. Access to the Sensu
Enterprise Console API is controlled by access tokens, which correspond to a
role definition (see the [`roles` specification `accessToken` attribute,
below][15]). RBAC for the Console API provides granular controls for restricting
access to specific API endpoints and HTTP methods (e.g. it is possible to allow
HTTP `GET` access to the [Clients API][16], but not `DELETE` access; see the
[`roles` specification `methods` attribute, below][15]).

### Providing an access token

In a header:

~~~ shell
$ curl -H "Authorization: token TOKEN" https://localhost:3000/events
~~~

As a parameter:

~~~ shell
$ curl https://localhost:3000/events?token=TOKEN
~~~

## RBAC configuration

### Example RBAC definition

The following is an example RBAC configuration using the [RBAC for LDAP][7]
authentication driver, a JSON configuration file located at
`/etc/sensu/dashboard.json`.

~~~ json
{
  "dashboard": {
    "host": "0.0.0.0",
    "port": 3000,
    "...": "",
    "ldap": {
      "server": "localhost",
      "port": 389,
      "basedn": "cn=users,dc=domain,dc=tld",
      "binduser": "cn=binder,cn=users,dc=domain,dc=tld",
      "bindpass": "secret",
      "roles": [
        {
          "name": "guests",
          "members": [
            "guests_group"
          ],
          "datacenters": [
            "us-west-1"
          ],
          "subscriptions": [
            "webserver"
          ],
          "readonly": true
        },
        {
          "name": "operators",
          "members": [
            "operators_group"
          ],
          "datacenters": [],
          "subscriptions": [],
          "readonly": false
        }
      ]
    }
  }
}
~~~

### RBAC definition specification

#### `DRIVER` attributes

Role based access controls for Sensu Enterprise are configured within the
`{ "dashboard": { "DRIVER": {} } }` configuration scope, where `DRIVER` is one
of the following:

- `ldap` (see [RBAC for LDAP][7])
- `github` (see [RBAC for GitHub][8])
- `gitlab` (see [RBAC for GitLab][9])

#### `roles` attributes

Role attributes are defined within the corresponding [RBAC `DRIVER`][10]
[configuration scope][17]; e.g.: `{ "dashboard": { "DRIVER": { "roles": [] } }
}`. The `roles` attribute is always a JSON array (i.e. `"roles": []`),
containing JSON hashes of role definitions. The following role definition
specification is common across all RBAC drivers.

##### EXAMPLE {#roles-attributes-example}

~~~ json
{
  "dashboard": {
    "...": "...",
    "ldap": {
      "...": "...",
      "roles": [
        {
          "name": "example_role",
          "members": ["example_group"],
          "datacenters": [],
          "subscriptions": ["example_application"],
          "readonly": false
        }
      ]
    }
  }
}
~~~

##### ATTRIBUTES {#roles-attributes-specification}

`name`
: description
  : The name of the role.
: required
  : true
: type
  : String
: example
  : ~~~shell
    "name": "operators"
    ~~~

`members`
: description
  : An array of the LDAP groups, GitHub Teams, or GitLab Groups that should be
    included as members of the role.
: required
  : true
: type
  : Array
: allowed values
  : Any LDAP group name, GitHub `organization/team` pair, or GitLab Group name.
    _NOTE: For LDAP group names, Sensu Enterprise supports the following LDAP
    group object classes: `group`, `groupOfNames`, `groupOfUniqueNames` and
    `posixGroup`._
    _NOTE: A GitHub Team with a URL of [github.com/orgs/sensu/teams/docs][11]
    would be entered as `sensu/docs`._
    _NOTE: A GitLab Group with a URL of [gitlab.com/groups/heavywater][12] would
    be entered as `heavywater`._
: example
  : ~~~shell
    "members": [
      "myorganization/devs",
      "myorganization/ops"
    ]
    ~~~

`datacenters`
: description
  : An array of the `datacenters` (i.e. matching a defined [Sensu API endpoint
    `name`][13] value) that members of the role
    should have access to. Provided values will be used to filter which
    `datacenters` members of the role will have access to.
    _NOTE: omitting this configuration attribute or providing an empty array
    will allow members of the role access to all configured `datacenters`._
: required
  : false
: type
  : Array
: example
  : ~~~shell
    "datacenters": [
      "us-west-1",
      "us-west-2"
    ]
    ~~~

`subscriptions`
: description
  : An array of the subscriptions that members of the role should have access
    to. Provided values will be used to filter which subscriptions members of
    the role will have access to.
    _NOTE: omitting this configuration attribute or providing an empty array
    will allow members of the role access to all subscriptions._
: required
  : false
: type
  : Array
: example
  : ~~~shell
    "subscriptions": [
      "webserver"
    ]
    ~~~

`readonly`
: description
  : Used to restrict "write" access (i.e. preventing members of the role from
    being able to create stashes, silence checks, etc).
: required
  : false
: type
  : Boolean
: default
  : false
: example
  : ~~~ shell
    "readonly": true
    ~~~

`accessToken`
: description
  : A unique token for [authenticating][19] against the [Sensu Enterprise
    Console API][14] as a member of that role.
: required
  : false
: type
  : String
: allowed values
  : any length string that only contains URL-friendly characters.
    _PRO TIP: we recommend using a random string generator for access tokens;
    e.g.: <br>
    `openssl rand -base64 40 |  tr -- '+=/' '-_~'`._
: example
  : ~~~shell
    "accessToken": "OrIXC7ezuq0AZKoRHhf~oIl-98dX5B23hf8KudfcqJt5eTeQjDDGDQ__"
    ~~~

`methods`
: description
  : The [`methods` definition scope][18], used to configure access to the [Sensu
    Enterprise Console API][14].
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "methods": {
      "head": [
        "none"
      ],
      "get": [],
      "post": [
        "results",
        "stashes"
      ],
      "delete": [
        "stashes"
      ]
    }
    ~~~

#### `methods` attributes

Sensu Enterprise Console API access controls may be fine tuned using the
`{ "dashboard": { "DRIVER": { "roles": [ { "methods": {} } ] } } }`
[configuration scope][17].

##### EXAMPLE {#methods-attributes-example}

~~~ json
{
  "dashboard": {
    "...": "...",
    "ldap": {
      "...": "...",
      "roles": [
        {
          "name": "example_role",
          "members": ["example_group"],
          "datacenters": [],
          "subscriptions": ["example_application"],
          "accessToken": "j3sJ8itFn9d9ooFYdN9erW3ZN6i8C9V3",
          "methods": {
            "get": [],
            "post": [
              "clients",
              "stashes"
            ],
            "delete": [
              "none"
            ]
          }
        }
      ]
    }
  }
}
~~~

##### SPECIFICATION {#methods-attributes-specification}

`get`
: description
  : Used to configure HTTP `GET` access to one or more [Sensu Enterprise
    Console API][14] endpoints.
: required
  : false
: type
  : Array of Strings
: allowed values
  : `aggregates`, `checks`, `clients`, `events`, `results`, `stashes`,
    `subscriptions`, and `datacenters`.
: default
  : `[]` (an empty array, which is equivalent to "allow all")
: example
  : ~~~ shell
    "methods": {
      "get": [
        "clients",
        "checks",
        "events"
      ]
    }
    ~~~

`post`
: description
  : Used to configure HTTP `POST` access to one or more [Sensu Enterprise
    Console API][14] endpoints.
: required
  : false
: type
  : Array of Strings
: allowed values
  : `aggregates`, `checks`, `clients`, `events`, `results`, `stashes`,
    `subscriptions`, and `datacenters`.
: default
  : `[]` (an empty array, which is equivalent to "allow all")
: example
  : ~~~ shell
    "methods": {
      "post": [
        "clients",
        "checks",
        "events"
      ]
    }
    ~~~

`delete`
: description
  : Used to configure HTTP `DELETE` access to one or more [Sensu Enterprise
    Console API][14] endpoints.
: required
  : false
: type
  : Array of Strings
: allowed values
  : `aggregates`, `checks`, `clients`, `events`, `results`, `stashes`,
    `subscriptions`, and `datacenters`.
: default
  : `[]` (an empty array, which is equivalent to "allow all")
: example
  : ~~~ shell
    "methods": {
      "delete": [
        "clients",
        "checks",
        "events"
      ]
    }
    ~~~

`head`
: description
  : Used to configure HTTP `HEAD` access to one or more [Sensu Enterprise
    Console API][14] endpoints.
: required
  : false
: type
  : Array of Strings
: allowed values
  : `aggregates`, `checks`, `clients`, `events`, `results`, `stashes`,
    `subscriptions`, and `datacenters`.
: default
  : `[]` (an empty array, which is equivalent to "allow all")
: example
  : ~~~ shell
    "methods": {
      "head": [
        "clients",
        "checks",
        "events"
      ]
    }
    ~~~



[?]:  #
[0]:  /enterprise
[1]:  https://github.com
[2]:  https://enterprise.github.com/home
[3]:  https://gitlab.com
[4]:  ../dashboard.html#what-is-a-sensu-datacenter
[5]:  ../../reference/clients.html#client-subscriptions
[6]:  ../api.html
[7]:  rbac-for-ldap.html
[8]:  rbac-for-github.html
[9]:  rbac-for-gitlab.html
[10]: #driver-attributes
[11]: https://github.com/orgs/sensu/teams/docs
[12]: https://gitlab.com/groups/heavywater
[13]: ../dashboard.html#sensu-attributes
[14]: ../dashboard.html#what-is-the-sensu-enterprise-console
[15]: #roles-attributes
[16]: ../../api/clients-api.html
[17]: ../../reference/configuration.html#configuration-scopes
[18]: #methods-attributes
[19]: #providing-an-access-token
