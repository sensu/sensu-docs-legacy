---
title: "Enterprise API"
version: 0.28
weight: 4
next:
  url: "contact-routing.html"
  text: "Contact Routing"
---

# Sensu Enterprise API

## Reference documentation

- [What is the Sensu Enterprise API?](#what-is-the-sensu-enterprise-api)
- [Enterprise API Configuration](#enterprise-api-configuration)
  - [Example(s)](#examples)
  - [API specification](#api-specification)
    - [`api` attributes](#api-attributes)
    - [`ssl` attributes](#ssl-attributes)
- [Create an SSL keystore](#create-an-ssl-keystore)
- [Configure the Enterprise API for SSL](#configure-the-enterprise-api-for-ssl)

--------------------------------------------------------------------------------

## What is the Sensu Enterprise API?

Every instance of Sensu Enterprise provides the Sensu Enterprise API, built upon
the [Sensu Core API][1].

The Sensu Enterprise API has the functionality of the Core API with the addition
of several endpoints to provide access to data for generating reports,
visualizing internal metrics, and more. The Enterprise API also supports native
SSL, for end-to-end SSL, eliminating the need for a proxy to terminate SSL.

## Enterprise API Configuration

### Example(s)

The following is an example API definition at `/etc/sensu/conf.d/api.json`.

~~~ json
{
  "api": {
    "host": "57.43.53.22",
    "bind": "0.0.0.0",
    "port": 4567,
    "ssl": {
      "port": 4568,
      "keystore_file": "/etc/sensu/api.keystore",
      "keystore_password": "secret"
    }
  }
}
~~~

### API specification

#### `api` attributes

The following attributes are configured within the `{"api": {} }` [configuration
scope][2].

`host`
: description
  : The hostname or IP address that is used when querying the API. This
    attribute does not configure the address that the API binds to (that's
    `bind`). This attribute is used by Sensu tooling to know how to query the
    Sensu API.
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

`bind`
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

`port`
: description
  : The API HTTP port.
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

`ssl`
: description
  : A set of attributes that configure SSL encryption for the API. The API SSL
    listener will be enabled if this attribute is configured.
: required
  : false
: type
  : Hash
: example
  : ~~~ shell
    "ssl": {}
    ~~~

#### `ssl` attributes

The following attributes are configured within the `{"api": { "ssl": {} } }`
[configuration scope][2].

##### EXAMPLE {#ssl-attributes-example}

~~~ json
{
  "api": {
    "host": "57.43.53.22",
    "...": "...",
    "ssl": {
      "port": 4568,
      "keystore_file": "/etc/sensu/api.keystore",
      "keystore_password": "secret"
    }
  }
}
~~~

##### ATTRIBUTES {#ssl-attributes-specification}

`port`
: description
  : The API HTTPS (SSL) port.
: required
  : true
: type
  : Integer
: example
  : ~~~ shell
    "port": 4458
    ~~~

`keystore_file`
: description
  : The file path for the SSL certificate keystore. The documentation to create
    self-signed SSL certificates and a keystore can be found [here][3].
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "keystore_file": "/etc/sensu/api.keystore"
    ~~~

`keystore_password`
: description
  : The SSL certificate keystore password.
: required
  : true
: type
  : String
: example
  : ~~~ shell
    "keystore_password": "secret"
    ~~~

## Create an SSL keystore

The following instructions will generate an OpenSSL certificate authority,
self-signed certificates, and a password protected keystore for the Sensu
Enterprise API. Alternatively, you may create a keystore with third-party issued
SSL certificates.

### Install OpenSSL

OpenSSL is required on the machine that will generate the SSL certificates.
Install OpenSSL on your platform:

#### Ubuntu/Debian

~~~ shell
sudo apt-get update
sudo apt-get install openssl
openssl version
~~~

#### CentOS/RHEL

~~~ shell
sudo yum install openssl
openssl version
~~~

### Generate SSL certificates and keystore

The generate an OpenSSL certificate authority, self-signed certificates, and a
password protected keystore for the Sensu Enterprise API, run the following
commands, providing information when prompted:

Create a password protected private key.

~~~ shell
openssl genrsa -des3 -out api.key 2048
~~~

Remove the password from the private key.

~~~ shell
cp api.key api.orig.key
openssl rsa -in api.orig.key -out api.key
~~~

Create a self-signed certificate.

~~~ shell
openssl req -new -x509 -key api.key -out apix509.crt
~~~

Combine the self-signed certificate and private key and export it in the pkcs12
format.

~~~ shell
openssl pkcs12 -inkey api.key -in apix509.crt -export -out api.pkcs12
~~~

Create the SSL keystore, importing `api.pkcs12`.

~~~ shell
keytool -importkeystore -srckeystore api.pkcs12 -srcstoretype PKCS12 -destkeystore api.keystore
~~~

The generated keystore should be moved to an appropriate directory to limit
access and allow Sensu Enterprise to load it. Move `api.keystore` to
`/etc/sensu` and correct the file ownership and permissions.

~~~ shell
sudo mv api.keystore /etc/sensu/
sudo chown sensu:sensu /etc/sensu/api.keystore
sudo chmod 600 /etc/sensu/api.keystore
~~~

## Configure the Enterprise API for SSL

Once you have successfully [created an SSL certificate keystore][3], Sensu
Enterprise can be configured to provide an SSL listener for the API (HTTPS). The
[keystore instructions][3] produced a password protected keystore at
`/etc/sensu/api.keystore`, the following API definition examples loads it.

The following is an example API definition at `/etc/sensu/conf.d/api.json`.

~~~ json
{
  "api": {
    "host": "your_api_host_address",
    "bind": "0.0.0.0",
    "port": 4567,
    "ssl": {
      "port": 4568,
      "keystore_file": "/etc/sensu/api.keystore",
      "keystore_password": "your_keystore_password"
    }
  }
}
~~~

Be sure to reload Sensu Enterprise to pick up the configuration changes.

_NOTE: The `service` command will not work on CentOS 5, the sysvinit
script must be used, e.g. `sudo /etc/init.d/sensu-enterprise start`_

~~~ shell
sudo service sensu-enterprise reload
~~~

[?]:  #
[1]:  ../api/overview.html
[2]:  ../reference/configuration.html#configuration-scopes
[3]:  #create-an-ssl-keystore
[4]:  dashboard.html
