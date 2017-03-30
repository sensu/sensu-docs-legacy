---
title: "Sensu Dashboard"
version: 0.29
weight: 2
next:
  url: "rbac/overview.html"
  text: "Role Based Access Controls"
---

# Sensu Enterprise Dashboard

## Reference Documentation

- [What is the Sensu Enterprise Dashboard?](#what-is-the-sensu-enterprise-dashboard)
  - [What is Uchiwa?](#what-is-uchiwa)
  - [What is the Sensu Enterprise Console?](#what-is-the-sensu-enterprise-console)
- [What is a Sensu "datacenter"?](#what-is-a-sensu-datacenter)
- [Dashboard configuration](#dashboard-configuration)
  - [Example dashboard configuration](#example-dashboard-configuration)
  - [Dashboard configuration attributes](#dashboard-configuration-attributes)
    - [`sensu` attributes](#sensu-attributes)
    - [`dashboard` attributes](#dashboard-attributes)
    - [`auth` attributes](#auth-attributes)
    - [`audit` attributes](#audit-attributes)
    - [`github` attributes](#github-attributes)
    - [`gitlab` attributes](#gitlab-attributes)
    - [`ldap` attributes](#ldap-attributes)
    - [`oidc` attributes](#oidc-attributes)

## What is the Sensu Enterprise Dashboard?

The Sensu Enterprise Dashboard is a simple web-based application that provides
realtime visibility into Sensu monitoring data, with dedicated views for
monitoring events, clients, checks, aggregates, [data centers][?], and more. The
dashboard provides powerful global search features for filtering views so users
can focus on the data that's important to them. The dashboard also provides
basic operational controls to acknowledge or otherwise "silence" monitoring
events, request ad hoc execution of monitoring checks, and much more.

### What is Uchiwa?

The Sensu Enterprise Dashboard is based on the open-source &ndash; and
community developed &ndash; [Uchiwa][2] dashboard. Very much like the
relationship between Sensu Core and Sensu Enterprise, the Sensu Enterprise
Dashboard builds on top of Uchiwa via a number of added-value extensions (e.g.
[Role Based Access Controls][3]; [LDAP][4], [GitHub][5], and [GitLab][6]
authentication; [Audit Logging][7]; etc), which development also results in
many contributions to the open-source Uchiwa dashboard project.

### What is the Sensu Enterprise Console?

The Sensu Enterprise Console is a federated API endpoint provided by the Sensu
Enterprise Dashboard for API access to multiple [Sensu datacenters][1]
(available in Sensu Enterprise Dashboard version 1.10 and newer). This API
provides added-value features including token-based authentication and [granular
role-based access controls][16].

_NOTE: the Sensu Enterprise Dashboard is comprised of two components: a backend
service (API) for aggregating monitoring data from one or more [Sensu
datacenters][5], and a web application for displaying this information. As of
Sensu Enterprise Dashboard version 1.10, this Sensu Enterprise Dashboard backend
has been updated so that it provides the same API endpoints as the [Sensu
API][1]. Prior to version 1.10, the Sensu Enterprise Dashboard backend used
different API routes for accessing data from specific datacenters; for example,
client data was accessible via `/clients/us-west-1/:client` instead of
`/clients/:client?dc=us-west-1`. Version 1.11 introduced access token-based
authentication, and version 1.12 introduced RBAC for the Console API._

## What is a Sensu "datacenter"?

The Sensu Enterprise Dashboard provides access to monitoring data from one or
more Sensu "datacenters". A Sensu datacenter is simply a Sensu API endpoint,
which corresponds to a Sensu installation consisting of one or more Sensu
servers in cluster (multiple API endpoints may be provided by a single Sensu
installation or cluster).

## Dashboard configuration

### Example dashboard configuration

The following is the bare minimum that should be included in your Sensu
Enterprise Dashboard configuration.

~~~ json
{
  "sensu": [
    {
      "name": "sensu-server-1",
      "host": "api1.example.com",
      "port": 4567
    }
  ],
  "dashboard": {
    "host": "0.0.0.0",
    "port": 3000
  }
}
~~~

_NOTE: the Sensu Enterprise Dashboard requires two configuration scopes: `sensu`
and `dashboard` (see [Dashboard definition specification][8], below)._

### Dashboard definition specification

The Sensu Enterprise dashboard uses two [configuration scopes][9]: the
`{ "sensu": {} }` configuration scope provides connection details for one or
more Sensu API endpoints (i.e. [datacenters][1]), and the `{ "dashboard": {} }`
configuration scope is used to configure the behavior of the dashboard itself.

_NOTE: by default, the Sensu Enterprise Dashboard will load configuration from
`/etc/sensu/dashboard.json` and/or from JSON configuration files located in
`/etc/sensu/dashboard.d/**.json`, with the same configuration merging behavior
as described [here][10]._

#### `sensu` attributes

name
: description
  : The name of the Sensu API (used elsewhere as the `datacenter` name).
: required
  : false
: type
  : String
: default
  : randomly generated
: example
  : ~~~ shell
    "name": "us-west-1"
    ~~~

host
: description
  : The hostname or IP address of the Sensu API.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "host": "127.0.0.1"
    ~~~

port
: description
  : The port of the Sensu API.
: required
  : false
: type
  : Integer
: default
  : 4567
: example
  : ~~~ shell
    "port": 4567
    ~~~

ssl
: description
  : Determines whether or not to use the HTTPS protocol.
: required
  : false
: type
  : Boolean
: default
  : false
: example
  : ~~~ shell
    "ssl": true
    ~~~

insecure
: description
  : Determines whether or not to accept an insecure SSL certificate.
: required
  : false
: type
  : Boolean
: default
  : false
: example
  : ~~~ shell
    "insecure": true
    ~~~

path
: description
  : The path of the Sensu API. Leave empty unless your Sensu API is not mounted
    to `/`.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "path": "/my_api"
    ~~~

timeout
: description
  : The timeout for the Sensu API, in seconds.
: required
  : false
: type
  : Integer
: default
  : 5
: example
  : ~~~ shell
    "timeout": 15
    ~~~

user
: description
  : The username of the Sensu API. Leave empty for no authentication.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "user": "my_sensu_api_username"
    ~~~

pass
: description
  : The password of the Sensu API. Leave empty for no authentication.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "pass": "my_sensu_api_password"
    ~~~

#### `dashboard` attributes

host
: description
  : The hostname or IP address on which Sensu Enterprise Dashboard will listen
    on.
: required
  : false
: type
  : String
: default
  : "0.0.0.0"
: example
  : ~~~ shell
    "host": "1.2.3.4"
    ~~~

port
: description
  : The port on which Sensu Enterprise Dashboard and Console API will listen on.
: required
  : false
: type
  : Integer
: default
  : 3000
: example
  : ~~~ shell
    "port": 3000
    ~~~

refresh
: description
  : Determines the interval to poll the Sensu APIs, in seconds.
: required
  : false
: type
  : Integer
: default
  : 5
: example
  : ~~~ shell
    "refresh": 5
    ~~~

ssl
: description
  : A hash of SSL configuration for native SSL support.
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "ssl": {
        "certfile": "/path/to/dashboard.pem",
        "keyfile": "/path/to/dashboard.key"
    }
    ~~~

user
: description
  : A username to enable simple authentication and restrict access to the
    dashboard. Leave blank along with `pass` to disable simple authentication.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "user": "admin"
    ~~~

pass
: description
  : A password to enable simple authentication and restrict access to the
    dashboard. Leave blank along with `user` to disable simple authentication.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "pass": "secret"
    ~~~

auth
: description
  : The [`auth` definition scope][11], used to configure JSON Web Token (JWT)
    authentication signatures.
: required
  : false
: type
  : Hash
: example
  : ~~~shell
    "auth": {
      "privatekey": "/path/to/console.rsa",
      "publickey": "/path/to/console.rsa.pub"
    }
    ~~~

audit
: description
  : The [`audit` definition scope][12], used to configure [Audit Logging][7]
    for the Sensu Enterprise Dashboard.
: required
  : false
: type
  : Hash
: example
  : ~~~shell
    "audit": {
      "logfile": "/var/log/sensu/sensu-enterprise-dashboard-audit.log",
      "level": "default"
    }
    ~~~

github
: description
  : The [`github` definition scope][14], used to configure [Role Based Access
    Controls][3] with the [RBAC for GitHub driver][5]. Overrides simple
    authentication.
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "github": {
      "clientId": "a8e43af034e7f2608780",
      "clientSecret": "b63968394be6ed2edb61c93847ee792f31bf6216",
      "server": "https://github.com",
      "roles": [
        {
          "name": "guests",
          "members": [
            "myorganization/devs"
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
            "myorganization/owners"
          ],
          "datacenters": [],
          "subscriptions": [],
          "readonly": false
        }
      ]
    }
    ~~~

gitlab
: description
  : The [`gitlab` definition scope][15], used to configure [Role Based Access
    Controls][3] with the [RBAC for GitLab driver][6]. Overrides simple
    authentication.
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "gitlab": {
      "clientId": "a8e43af034e7f2608780",
      "clientSecret": "b63968394be6ed2edb61c93847ee792f31bf6216",
      "server": "https://github.com",
      "roles": [
        {
          "name": "guests",
          "members": [
            "myorganization/devs"
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
            "myorganization/owners"
          ],
          "datacenters": [],
          "subscriptions": [],
          "readonly": false
        }
      ]
    }
    ~~~

ldap
: description
  : The [`ldap` configuration scope][13], used to configure [Role Based Access
    Controls][3] with the [RBAC for LDAP driver][4]. Overrides simple
    authentication.
: required
  : false
: type
  : Hash
: example
  : ~~~shell
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
      ],
      "insecure": false,
      "security": "none",
      "userattribute": "sAMAccountName"
    }
    ~~~

oidc
: description
  : The [`oidc` definition scope][18], used to configure [Role Based Access
    Controls][3] with the [RBAC for OpenID Connect (OIDC) driver][17]. Overrides simple
    authentication.
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "oidc": {
      "clientId": "a8e43af034e7f2608780",
      "clientSecret": "b63968394be6ed2edb61c93847ee792f31bf6216",
      "insecure": false,
      "server": "https://localhost:9031",
      "roles": [
        {
          "name": "guests",
          "members": [
            "myorganization/devs"
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
            "myorganization/owners"
          ],
          "datacenters": [],
          "subscriptions": [],
          "readonly": false
        }
      ]
    }
    ~~~

#### `auth` attributes

_NOTE: By default, temporary keys are generated when the Sensu Enterprise
Dashboard starts. These keys are later destroyed once the process is stopped or
restarted. These keys are used for generating and validating the signatures of
the JSON Web Tokens (JWT) for authentication. Specifying static keys is
supported and is necessary when using Sensu Enterprise Console behind a load
balancer. Static keys can be configured by using the `auth` attributes detailed
below._

privatekey
: description
  : Path to a private RSA key used for generating and validating the signatures
    of the JSON Web Tokens (JWT) for authentication.
: required
  : false
: type
  : String
: example
  : ~~~shell
    "auth": {
      "privatekey": "/path/to/console.rsa"
    }
    ~~~

public
: description
  : Path to a public RSA key used for generating and validating the signatures
    of the JSON Web Tokens (JWT) for authentication.
: required
  : false
: type
  : String
: example
  : ~~~shell
    "auth": {
      "publickey": "/path/to/console.rsa.pub"
    }
    ~~~

#### `audit` attributes

Please see the [Sensu Enterprise Dashboard Audit Logging reference
documentation][7] for information on how to configure the dashboard for audit
logging purposes.

#### `github` attributes

Please see the [RBAC for GitHub reference documentation][5] for information on
how to configure the dashboard for RBAC with GitHub.com or GitHub Enterprise.

#### `gitlab` attributes

Please see the [RBAC for GitLab reference documentation][6] for information on
how to configure the dashboard for RBAC with GitLab.

#### `ldap` attributes

Please see the [RBAC for LDAP reference documentation][4] for information on how
to configure the dashboard for RBAC with LDAP.

#### `oidc` attributes

Please see the [RBAC for OIDC reference documentation][4] for information on how
to configure the dashboard for RBAC with OpenID Connect (OIDC).

[?]:  #
[1]:  #what-is-a-sensu-datacenter
[2]:  http://www.uchiwa.io
[3]:  rbac/overview.html
[4]:  rbac/rbac-for-ldap.html
[5]:  rbac/rbac-for-github.html
[6]:  rbac/rbac-for-gitlab.html
[7]:  rbac/audit-logging.html
[8]:  #dashboard-definition-specification
[9]:  ../reference/configuration.html#configuration-scopes
[10]: ../reference/configuration.html#configuration-merging
[11]: #auth-attributes
[12]: #audit-attributes
[13]: #ldap-attributes
[14]: #github-attributes
[15]: #gitlab-attributes
[16]: rbac/overview.html#rbac-for-the-sensu-enterprise-console-api
[17]: rbac/rbac-for-oidc.html
[18]: #oidc-attributes
