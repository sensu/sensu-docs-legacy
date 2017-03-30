---
title: "RBAC for GitHub"
description: "Reference documentation for the Sensu Enterprise Dashboard Role
  Based Access Controls (RBAC) for GitHub"
version: 0.28
weight: 3
---

**ENTERPRISE: Role based access controls are available for [Sensu Enterprise][6]
users only.**

## RBAC for GitHub (driver)

### Reference Documentation

- [What is RBAC for GitHub?](#what-is-rbac-for-github)
- [RBAC for GitHub configuration](#rbac-for-github-configuration)
  - [Example RBAC for GitHub definition](#example-rbac-for-github-definition)
  - [RBAC for GitHub definition specification](#rbac-for-github-definition-specification)
    - [`github` attributes](#github-attributes)
    - [`roles` attributes](#roles-attributes)
- [Register an OAuth Application in GitHub](#register-an-oauth-application-in-github)

## What is RBAC for GitHub?

The Sensu Enterprise Dashboard offers support for built-in [Role Based Access
Controls (RBAC)][0], which depends on using some external source of truth for
authentication. The Sensu Enterprise Dashboard RBAC for GitHub driver provides
support for using [GitHub.com][1] or a [GitHub Enterprise][2] installation for
RBAC authentication.

## RBAC for GitHub configuration

### Example RBAC for GitHub definition

~~~ json
{
  "dashboard": {
    "host": "0.0.0.0",
    "port": 3000,
    "...": "",
    "github": {
      "clientId": "a8e43af034e7f2608780",
      "clientSecret": "b63968394be6ed2edb61c93847ee792f31bf6216",
      "server": "https://github.com",
      "roles": [
        {
          "name": "guests",
          "members": [
            "myorganization/guests"
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
            "myorganization/operators"
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

### RBAC for GitHub definition specification

#### `github` attributes

clientId
: description
  : The GitHub OAuth Application "Client ID"
    _NOTE: requires [registration of an OAuth application in GitHub][3]._
: required
  : true
: type
  : String
: example
  : ~~~shell
    "clientId": "a8e43af034e7f2608780"
    ~~~

clientSecret
: description
  : The GitHub OAuth Application "Client Secret"
  _NOTE: requires [registration of an OAuth application in GitHub][3]._
: required
  : true
: type
  : String
: example
  : ~~~shell
    "clientSecret": "b63968394be6ed2edb61c93847ee792f31bf6216"
    ~~~

server
: description
  : The location of the GitHub server you wish to authenticate against.
: required
  : true
: type
  : String
: example
  : ~~~shell
    "server": "https://github.com"`
    ~~~

roles
: description
  : An array of [`roles` definitions][4].
: required
  : true
: type
  : Array
: example
  : ~~~shell
    "roles": [
      {
        "name": "guests",
        "members": [
          "myorganization/guests"
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
          "myorganization/operators"
        ],
        "datacenters": [],
        "subscriptions": [],
        "readonly": false
      }
    ]
    ~~~

#### `roles` attributes

Please see the [RBAC definition specification][5] for information on how to
configure RBAC roles.

## Register an OAuth Application in GitHub

To use GitHub for authentication requires registration of your Sensu Enterprise
Dashboard as a GitHub "application". Please note the following instructions to
register an OAuth application for Sensu Enterprise:

1. To register a GitHub OAuth application, please navigate to your GitHub
   organization settings page (e.g.
   `github.com/organizations/YOUR-GITHUB-ORGANIZATION/settings/applications`),
   and selection "Applications" => "Register new application".

   ![](../../img/enterprise-dashboard-github-app.png)

2. Give your application a name (e.g. "Sensu Enterprise Dashboard")

3. Provide the Authorization callback URL (e.g. `{HOSTNAME}/login/callback`)

   _NOTE: this URL does not need to be publicly accessible - as long as a user
   has network access to **both** GitHub.com **and** the callback URL, s/he will
   be able to authenticate; for example, this will allow users to authenticate
   to a Sensu Enterprise Dashboard service running on a private network as long
   as the user has access to the network (e.g. locally or via VPN)._

4. Select "Register application" and note the application Client ID and Client
   Secret.

   ![](../../img/enterprise-dashboard-github-secret.png)


[?]:  #
[0]:  overview.html
[1]:  https://github.com
[2]:  https://enterprise.github.com/home
[3]:  #register-an-oauth-application-in-github
[4]:  #roles-attributes
[5]:  overview.html#roles-attributes
[6]:  /enterprise
