---
title: "RBAC for LDAP"
description: "Reference documentation for the Sensu Enterprise Dashboard Role
  Based Access Controls (RBAC) for LDAP"
version: 0.26
weight: 2
---

**ENTERPRISE: Role based access controls are available for [Sensu Enterprise][5]
users only.**

## RBAC for LDAP (driver)

### Reference Documentation

- [What is RBAC for LDAP?](#what-is-rbac-for-ldap)
- [LDAP provider compatibility](#ldap-provider-compatibility)
- [RBAC for LDAP configuration](#rbac-for-ldap-configuration)
  - [Example RBAC for LDAP definition](#example-rbac-for-ldap-definition)
  - [RBAC for LDAP definition specification](#rbac-for-ldap-definition-specification)
    - [`ldap` attributes](#ldap-attributes)
    - [`roles` attributes](#roles-attributes)

## What is RBAC for LDAP?

The Sensu Enterprise Dashboard offers support for built-in [Role Based Access
Controls (RBAC)][0], which depends on using some external source of truth for
authentication. The Sensu Enterprise Dashboard RBAC for LDAP driver provides
support for using a **Lightweight Directory Access Protocol (LDAP)** provider
(e.g. [Microsoft Active Directory][1], [OpenLDAP][2], etc) for RBAC
authentication.

## LDAP provider compatibility

This driver is tested with **Microsoft Active Directory** (AD) and should be
compatible with any standards-compliant LDAP provider.

## RBAC for LDAP configuration

### Example RBAC for LDAP definition

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
      "insecure": false,
      "security": "starttls",
      "userattribute": "sAMAccountName",
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

### RBAC for LDAP definition specification

#### `ldap` attributes

`server`
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

`port`
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

`dialect`
: description
  : Which LDAP dialect to use (Microsoft Active Directory, or OpenLDAP).
: required
  : false
: type
  : String
: allowed values
  : `ad`, `openldap`
: example
  : ~~~ shell
    "dialect": "ad"
    ~~~

`basedn`
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

`groupbasedn`
: description
  : Overrides the `basedn` attribute for the group lookups.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "groupbasedn": "cn=groups,dc=domain,dc=tld"
    ~~~

`userbasedn`
: description
  : Overrides the `basedn` attribute for the user lookups.
: required
  : false
: type
  : String
: example
  : ~~~ shell
    "userbasedn": "cn=admins,dc=domain,dc=tld"
    ~~~

`binduser`
: description
  : The LDAP account that performs user lookups. We recommend to
    use a read-only account. Use the distinguished name (DN) format,
    such as `cn=binder,cn=users,dc=domain,dc=tld`.
    _NOTE: using a binder account is not required with Active Directory,
    although it is highly recommended._
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "binduser": "cn=binder,cn=users,dc=domain,dc=tld"
    ~~~

`bindpass`
: description
  : The password for the binduser.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "bindpass": "secret"
    ~~~

`insecure`
: description
  : Determines whether or not to skip SSL certificate verification (e.g. for
    self-signed certificates).
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

`security`
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

`userattribute`
: description
  : The LDAP attribute used to identify an account. You should typically use
    `sAMAccountName` for Active Directory and `uid` for other LDAP softwares,
    such as OpenLDAP, but it may vary.
: required
  : false
: type
  : String
: default
  : `sAMAccountName`
: example
  : ~~~ shell
    "userattribute": "uid"
    ~~~

`groupmemberattribute`
: description
  : The LDAP attribute used to identify the group memberships.
: required
  : false
: type
  : String
: default
  : `member`
: example
  : ~~~ shell
    "groupmemberattribute": "uniqueMember"
    ~~~

`userobjectclass`
: description
  : The LDAP object class used for the user accounts.
: required
  : false
: type
  : String
: default
  : `person`
: example
  : ~~~ shell
    "userobjectclass": "inetOrgPerson"
    ~~~

`groupobjectclass`
: description
  : The LDAP object class used for the groups.
: required
  : false
: type
  : String
: default
  : `groupOfNames`
: example
  : ~~~ shell
    "groupobjectclass": "posixGroup"
    ~~~

`roles`
: description
  : An array of [Role definitions][3] for LDAP groups.
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
    ~~~

`debug`
: description
  : Determines whether or not to output debug information about the LDAP
    connection.
    _WARNING: not recommended for production use. Sensitive information
    including usernames and passwords may be sent to the log files when
    enabled._
: required
  : false
: type
  : Boolean
: default
  : false
: example
  : ~~~ shell
    "debug": true
    ~~~


#### `roles` attributes

Please see the [RBAC definition specification][4] for information on how to
configure RBAC roles.

[?]:  #
[0]:  overview.html
[1]:  https://msdn.microsoft.com/en-us/library/aa362244(v=vs.85).aspx
[2]:  http://www.openldap.org/
[3]:  #roles-attributes
[4]:  overview.html#roles-attributes
[5]:  /enterprise 
