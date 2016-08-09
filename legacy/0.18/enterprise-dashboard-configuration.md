---
version: 0.18
category: "Enterprise Dashboard Docs"
title: "Enterprise Dashboard Reference Documentation"
next:
  url: "enterprise-dashboard-collections"
  text: "Enterprise Dashboard Collections"
---

# Overview

This reference document provides information to help you:

* Configure the Sensu Enterprise Dashboard
* Enable optional access controls

## Example configurations

### Minimal configuration

The following is the bare minimum that should be included in your Sensu
Enterprise Dashboard configuration.

~~~ json
{
  "sensu": [
    {
      "name": "Site 1",
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

### GitHub Authentication Configuration

The Sensu Enterprise dashboard includes support for using GitHub to authenticate
via OAuth, and mapping GitHub teams to Sensu Enterprise Dashboard roles.

#### Register an OAuth Application in GitHub

To use GitHub for authentication requires registration of your Sensu Enterprise
Dashboard as a GitHub "application". Please note the following instructions:

1. To register a GitHub OAuth application, please navigate to your GitHub
   organization settings page (e.g.
   `github.com/organizations/YOUR-GITHUB-ORGANIZATION/settings/applications`),
   and selection "Applications" => "Register new application".

   ![](img/enterprise-dashboard-github-app.png)

2. Give your application a name (e.g. "Sensu Enterprise Dashboard")

3. Provide the Authorization callback URL (e.g. `{HOSTNAME}/login/callback`)

   _NOTE: this URL does not need to be publicly accessible - as long as a user
   has network access to **both** GitHub.com **and** the callback URL, s/he will
   be able to authenticate; for example, this will allow users to authenticate
   to a Sensu Enterprise Dashboard service running on a private network as long
   as the user has access to the network (e.g. locally or via VPN)._

4. Select "Register application" and note the application Client ID and Client
   Secret.

   ![](img/enterprise-dashboard-github-secret.png)


### SQL authentication configuration

The following is an example of using SQL authentication (using MySQL) with Sensu
Enterprise Dashboard. See
[database connection attributes](#database-connection-attributes) for more
information on SQL configuration.

~~~ json
{
  "sensu": [
    {
      "name": "Site 1",
      "host": "api1.example.com",
      "port": 4567
    }
  ],
  "dashboard": {
    "host": "0.0.0.0",
    "port": 3000,
    "db": {
      "driver": "mymysql",
      "scheme": "tcp:MYSQL_HOST:MYSQL_PORT*DB_NAME/USERNAME/PASSWORD"
    }
  }
}
~~~


# Configuration attributes

sensu
: description
  : An array of hashes containing [Sensu API endpoint attributes](#sensu-attributes).
: required
  : true
: type
  : Array
: example
  : ~~~ shell
    "sensu": [
        {
            "name": "API Name",
            "host": "127.0.0.1",
            "port": 4567
        }
    ]
    ~~~

dashboard
: description
  : A hash of [dashboard configuration attributes](#dashboard-attributes).
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "dashboard": {
        "host": "0.0.0.0",
        "port": 3000,
        "refresh": 5
    }
    ~~~

## Sensu attributes

name
: description
  : The name of the Sensu API (used as datacenter name).
: required
  : false
: type
  : String
: default
  : randomly generated
: example
  : ~~~ shell
    "name": "Datacenter 1"
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
  : The path of the Sensu API. Leave empty unless your Sensu API is not mounted to `/`.
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

## Dashboard attributes

host
: description
  : The hostname or IP address on which Sensu Enterprise Dashboard will listen on.
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
  : The port on which Sensu Enterprise Dashboard will listen on.
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

github
: description
  : A hash of [GitHub authentication attributes](#github-authentication-attributes) to enable
    GitHub authentication via OAuth. Overrides simple authentication.
    _NOTE: GitHub authentication is only available in the Sensu Enterprise
    Dashbaord, not Uchiwa._
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
      "roles": {
        "guests": [
          "myorganization/devs"
        ],
        "operators": [
          "myorganization/owners"
        ]
      }
    }
    ~~~

ldap
: description
  : A hash of [LDAP authentication attributes](#ldap-authentication-attributes)
    to enable LDAP authentication. Overrides simple authentication.
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
      "roles": {
        "guests": [
          "guests_group"
        ],
        "operators": [
          "operators_group"
        ]
      },
      "security": "none"
    }
    ~~~

db
: description
  : A hash of [database connection attributes](#database-connection-attributes)
    to enable SQL authentication. Overrides simple authentication.
    _NOTE: This is only available in Sensu Enterprise Dashboard, not Uchiwa._
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "db": {
        "driver": "mymysql",
        "scheme": "tcp:127.0.0.1:3306*sensu/root/mypassword"
    }
    ~~~

### GitHub authentication attributes

clientId
: description
  : The GitHub OAuth Application "Client ID"
    _NOTE: requires [registration of an OAuth application in GitHub](#register-an-oauth-application-in-github)._
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
  _NOTE: requires [registration of an OAuth application in GitHub](#register-an-oauth-application-in-github)._
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
    _NOTE: currently, only GitHub.com is supported; there are known issues when
    attempting to connect to GitHub Enterprise servers that we are working on
    resolving and should have a fix for soon._
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
  : A hash of [Role attributes for GitHub Teams](#role-attributes-for-github-teams)
: required
  : true
: type
  : Hash
: example
  : ~~~shell
    "roles": {
      "guests": [
        "myorganization/devs"
      ],
      "operators": [
        "myorganization/owners"
      ]
    }
    ~~~

#### Role attributes for GitHub Teams

guests
: description
  : An array of the GitHub Teams that should be allowed "guest" (i.e.
    read-only) access.
: required
  : false
: type
  : Array
: allowed values
  : any valid `organization/team` pair. For example, the team located at
    [https://github.com/orgs/sensu/teams/owners](https://github.com/orgs/sensu/\
    teams/owners) would be entered as `sensu/owners`.
: example
  : ~~~shell
    "guests": ["myorganization/devs"]`
    ~~~

operators
: description
  : An array of the GitHub Teams that should be allowed "operator" (i.e. read +
    write) access.
: required
  : true
: type
  : Array
: allowed values
  : any valid `organization/team` pair. For example, the team located at
    [https://github.com/orgs/sensu/teams/owners](https://github.com/orgs/sensu/\
    teams/owners) would be entered as `sensu/owners`.
: example
  : ~~~shell
    "operators": ["myorganization/owners"]
    ~~~

### LDAP authentication attributes

This driver is tested with **Microsoft Active Directory** (AD) and should be
compatible with any LDAP directory.

server
: description
  : **IP address** or **FQDN** of the LDAP directory or the Microsoft Active
    Directory domain controller.
: required
  : true
: type
  : String
: example
  : ~~~shell
    "server": "localhost"
    ~~~

port
: description
  : Port of the LDAP/AD service (usually `389` or `636`)
: required
  : true
: type
  : Integer
: example
  : ~~~ shell
    "port": 389
    ~~~

basedn
: description
  : Tells which part of the directory tree to search. For example,
    `cn=users,dc=domain,dc=tld` will search into all `users` of the
    `domain.tld` directory.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "basedn": "cn=users,dc=domain,dc=tld"
    ~~~

security
: description
  : Determines the encryption type to be used for the connection to the LDAP
    server.
: required
  : true
: type
  : String
: allowed values
  : `none`, `starttls`, or `tls`
: example
  : ~~~ shell
    "security": "none"
    ~~~

roles
: description
  : A hash of [Role attributes for LDAP groups](#role-attributes-for-ldap-groups)
: required
  : true
: type
  : Hash
: example
  : ~~~ shell
    "roles": {
      "guests": [
        "guests_group"
      ],
      "operators": [
        "operators_group"
      ]
    }
    ~~~

#### Role attributes for LDAP groups

guests
: description
  : An array of LDAP groups that should be allowed "guest" (i.e. read-only)
    access.
: required
  : true
: type
  : Array
: example
  : ~~~ shell
    "guests": ["guests_group"]
    ~~~

operators
: description
  : An array of LDAP groups that should be allowed "guest" (i.e. read + write)
    access.
: required
  : true
: type
  : Array
: example
  : ~~~ shell
    "operators": ["operators_group"]
    ~~~



### Database connection attributes

_NOTE: a default user of `admin` will automatically be created with the password
`sensu`. This user will be created when the Sensu Enterprise Dashboard service
starts._

_NOTE: when using the `mymysql` or `postgres` drivers, you must first create the
database you specify._

driver
: description
  : The name of the database driver to use for SQL authentication.
: required
  : true
: type
  : String
: allowed values
  : - `mymysql` - For MySQL
    - `postgres` - For PostgreSQL (versions >= 9.x)
    - `sqlite3` - For SQLite
: example
  : ~~~ shell
    "driver": "postgres"
    ~~~

scheme
: description
  : The scheme to use to connect to the corresponding database driver.
    _NOTE: use the [scheme syntax](#scheme-syntax) that corresponds with the
    database driver you choose._
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "scheme": "dashboard.db"
    ~~~

#### Scheme syntax

mymysql
: syntax
  : ~~~ shell
    "scheme": "tcp:MYSQL_HOST:MYSQL_PORT*DB_NAME/USERNAME/PASSWORD"
    ~~~
: example
  : ~~~ shell
    "scheme": "tcp:127.0.0.1:3306*sensu/root/mypassword"
    ~~~

postgres
: syntax
  : ~~~ shell
    "scheme": "user=USERNAME dbname=DB_NAME host=HOST password=PASSWORD sslmode=disable"
    ~~~
: example
  : ~~~ shell
    "scheme": "user=postgres dbname=sensu host=127.0.0.1 password=mypassword sslmode=disable"
    ~~~

sqlite3
: syntax
  : ~~~ shell
    "scheme": "FILENAME.db"
    ~~~
: example
  : ~~~ shell
    "scheme": "sensu.db"
    ~~~
