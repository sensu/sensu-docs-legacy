---
version: 0.17
category: "Configuration"
title: "Configuring Sensu Enterprise Dashboard"
next:
  url: "enterprise-dashboard-rbac"
  text: "Role-based Access Control"
info:
warning:
danger:
---

## Configuration

The `dashboard` object can contain the following attributes:

~~~ json
{
  "dashboard": {
    "host": "0.0.0.0",
    "port": 3000,
    "refresh": 5
  }
}
~~~

**host**
*String*. Address on which Uchiwa will listen. The default value is **0.0.0.0**.

**port**
*Integer*. Port on which Uchiwa will listen. The default value is **3000**.

**refresh**
*Integer*. Determines the interval to pull the Sensu APIs, in seconds. The default value is **5**.

### Simple authentication
In order to restrict the access to the dashboard, you can easily setup a single-user account with these attributes:

~~~ json
{
  "uchiwa": {
    "user": "admin",
    "pass": "secret"
  }
}
~~~

**user**
*String*. Username of the Uchiwa dashboard.

**pass**
*String*. Password of the Uchiwa dashboard.
