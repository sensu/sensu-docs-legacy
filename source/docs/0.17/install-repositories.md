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

Sensu Core is installed via software installer packages which are made available via software repositories for various platforms (e.g. APT repositories for Ubuntu/Debian, YUM repositories for CentOS/RHEL; installer packages for Microsoft Windows are also available). Sensu packages contain all of the Sensu services and their dependencies, with the exception of RabbitMQ & Redis. This ensures the simplest installation process, promotes consistency across installs, and prevents interference with other services.

Sensu Enterprise is also installed via software installer packages which are made available via software repositories for various platforms. Sensu Enterprise depends on a Java runtime for execution.

The following instructions will help you to:

- Install the Sensu Core repository
- [OPTIONAL] Install the Sensu Enterprise repository

# Install the Sensu Core Repository

## Ubuntu/Debian

Install the GPG public key, and create the APT repository configuration file for the Sensu Core repository:

~~~ shell
wget -q http://repos.sensuapp.org/apt/pubkey.gpg -O- | sudo apt-key add -
echo "deb     http://repos.sensuapp.org/apt sensu main" | sudo tee > /etc/apt/sources.list.d/sensu.list
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

_NOTE: access to the Sensu Enterprise repositories requires an active [Sensu Enterprise](http://sensuapp.org/enterprise#pricing) subscription, and valid access credentials._

## Set Access Credentials

Please set the following environment variables, replacing `USER` and `PASSWORD` with the access credentials provided with your Sensu Enterprise subscription:

~~~ shell
export SE_USER=USER
export SE_PASS=PASSWORD
~~~

## Ubuntu/Debian

Install the GPG public key, and create the APT repository configuration file for the Sensu Enterprise repository:

~~~ shell
wget -q http://$SE_USER:$SE_PASS@enterprise.sensuapp.com/apt/pubkey.gpg -O- | sudo apt-key add -
echo "deb     http://$SE_USER:$SE_PASS@enterprise.sensuapp.com/apt sensu-enterprise main" | sudo tee > /etc/apt/sources.list.d/sensu-enterprise.list
~~~

## CentOS/RHEL

Create the YUM repository configuration file for the Sensu Core repository at `/etc/yum.repos.d/sensu-enterprise.repo`:

~~~ shell
echo "[sensu-enterprise]
name=sensu-enterprise
baseurl=http://$SE_USER:$SE_PASS@enterprise.sensuapp.com/yum/noarch/
gpgcheck=0
enabled=1" | sudo tee > /etc/yum.repos.d/sensu.repo
~~~
