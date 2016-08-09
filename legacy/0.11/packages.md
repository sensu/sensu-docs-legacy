---
version: "0.11"
category: "Installation"
title: "Sensu packages"
---

# Sensu Packages

The Sensu project provides "monolithic" or "omnibus" packages which require no other
dependencies. They are self-contained and include almost everything
Sensu needs to function, including its own build of Ruby, and on Linux
platforms all installed in `/opt/sensu`. This ensures the simplest
installation process, promotes consistency across installs, and prevents
Sensu from interfering with other Ruby applications.

Choose either the main or unstable repos, don't use both at the same time.

The repositories are browseable: [http://repos.sensuapp.org/index.html](http://repos.sensuapp.org/index.html)

## Installing on Debian and Ubuntu via Apt

Tested on:

* Ubuntu 10.04, 11.04, 11.10, 12.04
* Debian 6

### Install the repository public key

First we need to install the repository public key on our host to use
the Sensu repositories.

~~~ bash
wget -q http://repos.sensuapp.org/apt/pubkey.gpg -O- | sudo apt-key add -
~~~

### Stable repository

~~~ bash
echo "deb     http://repos.sensuapp.org/apt sensu main" >/etc/apt/sources.list.d/sensu.list
~~~

### Unstable repository

~~~ bash
echo "deb     http://repos.sensuapp.org/apt sensu unstable" >/etc/apt/sources.list.d/sensu.list 
~~~

## Installing on Red Hat and CentOS via Yum

Tested on:

* CentOS (RHEL) 5, 6
* Fedora 15, 16, 17

### Stable repository

Add the following as Yum repository listings in `/etc/yum.repos.d`.

~~~ bash
[sensu]
name=sensu-main
baseurl=http://repos.sensuapp.org/yum/el/$releasever/$basearch/
gpgcheck=0
enabled=1
~~~

### Unstable repository

~~~ bash
[sensu-unstable]
name=sensu-unstable
baseurl=http://repos.sensuapp.org/yum-unstable/el/$releasever/$basearch/
gpgcheck=0
enabled=1
~~~

Valid values of `$releasever` are `5` and `6`.

If you get a 404 (such as if your `$releasever` expands to `5Server`), hardcode the value to 5 or 6.

Fedora systems will require hardcoding the $releasver variable. Choosing '6' should be fine for
at least Fedora 16 and 17. Later versions will be tested as necessary. The rpm's have not been
tested on Fedora versions less than 15 but may work.

## Installing on Windows via MSI

Tested on:

* Windows 2008 R2

### Download and install the MSI package

Find it in the msi directory: [http://repos.sensuapp.org/index.html](http://repos.sensuapp.org/index.html) 

