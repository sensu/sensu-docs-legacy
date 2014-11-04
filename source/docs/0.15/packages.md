---
version: "0.15"
category: "Installation"
title: "Sensu packages"
warning: "<strong>IMPORTANT NOTE:</strong> Sensu-Dashboard is no
longer included in the Sensu packages."
next:
  url: security
  text: "Security"
---

# Sensu packages {#sensu-packages}

The Sensu project provides "omnibus" packages, which contain all of
the Sensu components, and have no dependencies. The packages are
self-contained, having everything Sensu needs to run, with the
exception of RabbitMQ and Redis. This ensures the simplest
installation process, promotes consistency across installs, and
prevents Sensu from interfering with other applications. On Linux
platforms, the packages install to `/opt/sensu`, and place sysvinit
scripts in `/etc/init.d`.

Package formats:

* deb
* rpm
* msi

Each package format has its own main and unstable repository. The
unstable repositories are for experimental builds.

Choose either main or unstable, do not use both.

## Installing Sensu on Debian and Ubuntu using APT {#installing-sensu-on-debian-and-ubuntu-using-apt}

Tested on:

* Ubuntu 10.04, 11.04, 11.10, 12.04, 13.04, 13.10
* Debian 6

### Step #1 - Install the repository public key {#apt-install-the-respository-key}

First we need to install the repository public key on our host to use
the Sensu repositories.

~~~ shell
wget -q http://repos.sensuapp.org/apt/pubkey.gpg -O- | sudo apt-key add -
~~~

### Step #2 - Add the repository {#apt-add-the-repository}

Main repository (stable).

~~~ shell
echo "deb     http://repos.sensuapp.org/apt sensu main" > /etc/apt/sources.list.d/sensu.list
~~~

**Or** the **unstable** repository.

~~~ shell
echo "deb     http://repos.sensuapp.org/apt sensu unstable" > /etc/apt/sources.list.d/sensu.list
~~~

### Step #3 - Install Sensu {#apt-install-sensu}

~~~shell
apt-get update
apt-get install sensu
~~~

## Installing Sensu on CentOS (RHEL) using Yum {#installing-sensu-on-centos-and-rhel-using-yum}

Tested on:

* CentOS (RHEL) 5, 6
* Fedora 15, 16, 17

### Step #1 - Add the repository {#yum-add-the-repository}

Write the following content to `/etc/yum.repos.d/sensu.repo`.

Main repository (stable).

~~~ shell
[sensu]
name=sensu-main
baseurl=http://repos.sensuapp.org/yum/el/$releasever/$basearch/
gpgcheck=0
enabled=1
~~~

**Or** the **unstable** repository.

~~~ shell
[sensu-unstable]
name=sensu-unstable
baseurl=http://repos.sensuapp.org/yum-unstable/el/$releasever/$basearch/
gpgcheck=0
enabled=1
~~~

Valid values for `$releasever` are `5` and `6`.

If you get a 404 (such as if your `$releasever` expands to `5Server`),
hard-code the value to `5` or `6`.

**IMPORTANT NOTE** - Fedora systems will require hard-coding the
  $releasver variable. Choosing `6` should be fine for at least Fedora
  16 and 17. Later versions will be tested as necessary.

### Step #2 - Install Sensu {#yum-install-sensu}

~~~shell
yum install sensu
~~~

## Installing Sensu on Windows via MSI {#installing-sensu-on-windows-via-msi}

Tested on:

* Windows 2008 R2

### Step #1 - Download and install the MSI package {#windows-download-and-install-the-msi-package}

Find it in the msi directory: [http://repos.sensuapp.org/index.html](http://repos.sensuapp.org/index.html)
