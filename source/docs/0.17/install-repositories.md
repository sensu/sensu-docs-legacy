---
version: 0.17
category: "Installation Guide"
title: "Install Repositories"
next:
  url: "install-sensu"
  text: "Install Sensu"
info:
warning:
danger:
---

# Overview

Sensu is installed via software installer packages (deb, rpm, msi) which are made available via software repositories for various platforms (e.g. APT repositories for Ubuntu/Debian, YUM repositories for CentOS/RHEL; installer packages for Microsoft Windows are also available). Sensu packages contain all of the Sensu services and their dependencies, with the exception of RabbitMQ & Redis. This ensures the simplest installation process, promotes consistency across installs, and prevents interference with other services.

The following instructions will help you to:

- Install the Sensu Core repository
- [OPTIONAL] Install the Sensu Enterprise repository

# Install the Sensu Core Repository

## Ubuntu/Debian

Install the GPG public key, and create the APT repository configuration file for the Sensu Core repository:

~~~ shell
wget -q http://repos.sensuapp.org/apt/pubkey.gpg -O- | sudo apt-key add -
echo "deb     http://repos.sensuapp.org/apt sensu main" | sudo tee --append > /etc/apt/sources.list.d/sensu.list
~~~

## CentOS/RHEL

Create the YUM repository configuration file for the Sensu Core repository at `/etc/yum.repos.d/sensu.repo`: 

~~~ shell
echo '[sensu]
name=sensu
baseurl=http://repos.sensuapp.org/yum/el/$basearch/
gpgcheck=0
enabled=1' | sudo tee > /etc/yum.repos.d/sensu.repo
~~~

# Install the Sensu Enterprise Repository

# Sensu Enterprise installation {#enterprise-installation}




Sensu Enterprise is delivered in a native system package, containing an
executable Java JAR, accompanied by configuration files and service
scripts. Package installation creates the required directories and
system user.

The Sensu Enterprise native system package has a single dependency,
the Java runtime. The specific dependency package depends on the
system platform/distribution.

Debian (Ubuntu): `openjdk-7-jre`

RHEL (CentOS): `java-1.7.0-openjdk`

## Repository access

The Sensu Enterprise are available in private repositories, requiring
authentication. Access to the repositories requires an active Sensu Enterprise
subscription, repository credentials will be provided.

## Install

The following installation steps assume root access is available.

### Debian (Ubuntu) {#install-enterprise-debian}

Tested on:

* Ubuntu 12.04, 14.04
* Debian 6, 7

#### Step #1 - Install the repository public key {#apt-install-public-key}

Install the repository public key on the host.

_NOTE: replace `USER` and `PASSWORD` with your access credentials
provided with your Sensu Enterprise subscription._

~~~ shell
wget -q http://USER:PASSWORD@enterprise.sensuapp.com/apt/pubkey.gpg -O- | sudo apt-key add -
~~~

#### Step #2 - Add the repository {#apt-add-repository}

_NOTE: replace `USER` and `PASSWORD` with your access credentials
provided with your Sensu Enterprise subscription._

~~~ shell
echo "deb     http://USER:PASSWORD@enterprise.sensuapp.com/apt sensu-enterprise main" > /etc/apt/sources.list.d/sensu-enterprise.list
~~~

#### Step #3 - Install Sensu {#apt-install-enterprise}

~~~shell
apt-get update
apt-get install sensu-enterprise
~~~

### RHEL (CentOS) {#install-enterprise-rhel}

Tested on:

* CentOS 6, 7

### Step #1 - Add the repository {#yum-add-the-repository}

Write the following content to `/etc/yum.repos.d/sensu-enterprise.repo`.

_NOTE: replace `USER` and `PASSWORD` with your access credentials
provided with your Sensu Enterprise subscription._

~~~ shell
[sensu-enterprise]
name=sensu-enterprise
baseurl=http://USER:PASSWORD@enterprise.sensuapp.com/yum/noarch/
gpgcheck=0
enabled=1
~~~

#### Step #2 - Install Sensu Enterprise {#yum-install-enterprise}

~~~shell
yum install sensu-enterprise
~~~
