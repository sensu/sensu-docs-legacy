---
version: 0.18
category: "Enterprise Dashboard Docs"
title: "Enterprise Dashboard Reference Documentation"
next:
  url: "enterprise-dashboard-collections"
  text: "Enterprise Dashboard Collections"
---

# Overview

This documentation is based on the [Uchiwa documentation](http://uchiwa.readthedocs.org/en/latest/).

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
