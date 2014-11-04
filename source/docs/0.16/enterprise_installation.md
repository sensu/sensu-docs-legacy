---
version: "0.16"
category: "Enterprise"
title: "Installation"
next:
  url: enterprise_integrations
  text: "Enterprise integrations"
---

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
[sensu]
name=sensu-enterprise-main
baseurl=http://USER:PASSWORD@enterprise.sensuapp.com/yum/el/$releasever/$basearch/
gpgcheck=0
enabled=1
~~~

Valid values for `$releasever` are `5` and `6`.

If you get a 404 (such as if your `$releasever` expands to `5Server`),
hard-code the value to `5` or `6`.

#### Step #2 - Install Sensu Enterprise {#yum-install-enterprise}

~~~shell
yum install sensu-enterprise
~~~
