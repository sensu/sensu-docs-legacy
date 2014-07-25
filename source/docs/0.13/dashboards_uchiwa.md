---
version: "0.13"
category: "Dashboards"
title: "Uchiwa"
---

# Uchiwa

Uchiwa is a simple dashboard for the Sensu monitoring framework, built
with node.js.

Features:

- Support of multiple Sensu APIs
- Real-time updates with Socket.IO
- Easily filter events, clients, stashes and events
- Simple client details view
- Stash management
- Easy installation

See the Uchiwa
[README](https://github.com/sensu/uchiwa/blob/master/README.md) for information.

## Packages

The Sensu project provides "omnibus" Uchiwa packages, which contain
Uchiwa and all of its dependencies. This ensures the simplest
installation process, promotes consistency across installs, and
prevents Uchiwa from interfering with other applications. The packages
install to `/opt/uchiwa`, and place a sysvinit script at
`/etc/init.d/uchiwa`.

Package formats:

* deb
* rpm

The Uchiwa packages are available via the Sensu main (stable) and
unstable repositories. The unstable repositories are for experimental
builds.

See the [Sensu packages documentation](packages) for instructions on how to add
the Sensu repositories.

### Installing on Debian and Ubuntu using APT {#installing-on-debian-and-ubuntu-using-apt}

Tested on:

* Ubuntu 10.04, 12.04, 14.04

~~~ shell
apt-get update
apt-get install uchiwa
~~~

### Installing on CentOS (RHEL) using Yum {#installing-on-centos-and-rhel-using-yum}

Tested on:

* CentOS (RHEL) 6

~~~ shell
yum install uchiwa
~~~

## Configuration

Uchiwa's configuration file can be found at `/etc/sensu/uchiwa.js`.
The file must be readable by the `uchiwa` user, and the parent
directory must have the `sensu` group.

The `sensu` array items represent the Sensu API endpoints, as Uchiwa
support querying multiple.

You can configure the Uchiwa dashboard itself, using `uchiwa`.

~~~ javascript
  module.exports = {
      sensu: [
          {
              name: 'Sensu',
              host: '127.0.0.1',
              ssl: false,
              port: 4567,
              user: '',
              pass: '',
              path: '',
              timeout: 5000
          }
      ],
      uchiwa: {
          user: '',
          pass: '',
          port: 3000,
          stats: 10,
          refresh: 10000
      }
  }
~~~

## Service

To manage the Uchiwa service, use the package provided sysvinit script.

### Enable the service

#### Debian and Ubuntu {#service-enable-debian-and-ubuntu}

~~~ shell
update-rc.d uchiwa defaults
~~~

#### CentOS (RHEL) {#service-enable-centos-and-rhel}

~~~ shell
chkconfig uchiwa on
~~~

### Start the service

~~~ shell
/etc/init.d/uchiwa start
~~~
