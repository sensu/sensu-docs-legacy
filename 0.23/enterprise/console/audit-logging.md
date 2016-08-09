---
title: "Audit Logging"
version: 0.23
weight: 6
---

# Audit Logging

As of Sensu Enterprise Dashboard version 1.3, Audit Logging is enabled by
default. Audit Logging captures user events in the dashboard such as user
login/logout, and any user "write" actions in the dashboard (i.e. silencing
checks, deleting clients, deleting stashes). Optionally, it is also possible to
log all `HTTP GET` requests (i.e. every view requested by the user, and every
search query performed by the user).

### Example configuration

~~~ shell
"audit": {
  "logfile": "/var/log/sensu/sensu-enterprise-dashboard-audit.log",
  "level": "default"
}
~~~

### Audit Logging attributes

logfile
: description
  : The location of the audit logging logfile.
: required
  : false
: type
  : String
: default
  : `/var/log/sensu/sensu-enterprise-dashboard-audit.log`
: example
  : ~~~shell
    "logfile": "/var/log/sensu/sensu-enterprise-dashboard-audit.log"
    ~~~

level
: description
  : The audit logging level.
: required
  : false
: type
  : String
: default
  : `default`
: allowed values
  : `default`, `verbose`, `disabled`
  _NOTE: `default` log level events are user login/logout, and any user "write"
  actions in the dashboard (i.e. silencing checks, deleting clients, deleting
  stashes). The `verbose` log level includes all of the `default` log level
  events, plus all `HTTP GET` requests (i.e. every view requested by the user,
  and every search query performed by the user)._
: example
  : ~~~shell
    "level": "verbose"
    ~~~
