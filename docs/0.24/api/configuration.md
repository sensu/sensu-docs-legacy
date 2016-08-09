---
title: "API Configuration"
version: 0.24
weight: 9
info: "<strong>NOTE:</strong> Please visit the <a href='../enterprise/api.html'>
  Sensu Enterprise API reference documentation</a> for information on
  configuring the Sensu Enterprise API (including native SSL encryption)."
---

# Sensu API Configuration

## Reference documentation

- [API configuration](#api-configuration)
  - [Example API definition](#example-api-definition)
  - [API definition specification](#api-definition-specification)

## API configuration

### Example API definition

The following is an example API definition at `/etc/sensu/conf.d/api.json`.

~~~ json
{
  "api": {
    "host": "57.43.53.22",
    "bind": "0.0.0.0",
    "port": 4567
  }
}
~~~

### API definition specification

The API definition uses the `"api": {}` definition scope.

#### `api` attributes

host
: description
  : The hostname or IP address that is used when querying the API.
    _NOTE: this attribute does not configure the address that the API binds to
    (that's `bind`). This attribute is used by the Sensu server when querying
     the Sensu API._
: required
  : false
: type
  : String
: default
  : `127.0.0.1`
: example
  : ~~~ shell
    "host": "8.8.8.8"
    ~~~

bind
: description
  : The address that the API will bind to (listen on).
: required
  : false
: type
  : String
: default
  : `0.0.0.0`
: example
  : ~~~ shell
    "bind": "127.0.0.1"
    ~~~

port
: description
  : The port that the API will listen on for HTTP requests.
: required
  : false
: type
  : Integer
: default
  : `4567`
: example
  : ~~~ shell
    "port": 4242
    ~~~

user
: description
  : The username required to connect to the API.
: required
  : false
: depends
  : `password`
: type
  : String
: default
  : none
: example
  : ~~~ shell
    "user": "sensu"
    ~~~

password
: description
  : The password required to connect to the API.
: required
  : false
: depends
  : `user`
: type
  : String
: default
  : none
: example
  : ~~~ shell
    "password": "secret"
    ~~~
