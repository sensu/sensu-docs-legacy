---
version: 0.17
category: "Role-based Access Control"
title: "Role-based Access Control"
next:
  url: "enterprise-dashboard-collections"
  text: "Collections"
info:
warning:
danger:
---

## Role-based Access Control (RBAC)

The module contains the following database drivers:

* MySQL
* PostgreSQL (>= 9.x)
* SQLite

**Configuration**

A default user, **admin**, will be automatically created with the password
**uchiwa**.

### MySQL
You need to create the `DB_NAME` beforehand.

~~~ json
{
  "dashboard": {
    "db": {
      "driver": "mymysql",
      "scheme": "tcp:MYSQL_PORT:MYSQL_PORT*DB_NAME/USERNAME/PASSWORD"
    }
  }
}
~~~

### PostgreSQL
You need to create the `DB_NAME` beforehand.

~~~ json
{
  "uchiwa": {
    "db": {
      "driver": "postgres",
      "scheme": "user=USERNAME dbname=DB_NAME host=HOST password=PASSWORD sslmode=disable"
    }
  }
}
~~~

### SQLite

The `FILENAME.db` database file will automatically be created.

~~~ json
{
  "uchiwa": {
    "db": {
      "driver": "sqlite3",
      "scheme": "FILENAME.db"
    }
  }
}
~~~
