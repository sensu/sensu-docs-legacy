---
version: 0.22
category: "Installation Guide"
title: "Install RabbitMQ on RHEL/CentOS"
next:
  url: "install-redis"
  text: "Install Redis"
---

# Install RabbitMQ on RHEL/CentOS

- [Install Erlang (the RabbitMQ runtime)](#install-erlang)
- [Install RabbitMQ](#install-rabbitmq)
  - [Download and install RabbitMQ using `rpm` (recommended)](#download-and-install-rabbitmq-using-rpm)
  - [Install RabbitMQ using YUM](#install-rabbitmq-using-yum)
- [Managing the RabbitMQ service/process](#managing-the-rabbitmq-serviceprocess)
- [Configure RabbitMQ access controls](#configure-rabbitmq-access-controls)
- [Configuring system limits on Linux](#configuring-system-limits-on-linux)

_NOTE: this guide uses the official software repositories and packages for
Erlang and RabbitMQ, as many Linux distributions provide outdated versions that
contain known security vulnerabilities and bugs._

## Install Erlang (the RabbitMQ runtime) {#install-erlang}

RabbitMQ runs on the [Erlang runtime][erlang], so before you can install and run
RabbitMQ, you'll need to install Erlang.

1. Add the Erlang Solutions YUM repository:

   ~~~ shell
   sudo wget http://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
   sudo rpm -Uvh erlang-solutions-1.0-1.noarch.rpm
   ~~~

2. Install Erlang:

   ~~~
   redhat_release=`cat /etc/redhat-release | awk {'print int($3)'}`
   sudo yum install -y erlang-18.2-1.el${redhat_release}
   ~~~

   _NOTE: if you are using CentOS 7, you may need to install the EPEL repository
   prior to installing Erlang. Running `sudo yum install epel-release` will
   allow you to properly install Erlang on CentOS 7._

## Install RabbitMQ

According to the [official RabbitMQ installation guide][rabbitmq-install],
although RabbitMQ packages are included in the RPM-based distribution
repositories, downloading and installing RabbitMQ from the RabbitMQ website is
the recommended installation method.

> `rabbitmq-server` is included in [RPM-based distributions]. However, the
versions included are often quite old. You will probably get better results
installing the .rpm from our website. Check the [distribution] package details
for which version of the server is available for which versions of the
distribution.

### Download and install RabbitMQ using `rpm`

1. Download the signing key for the RabbitMQ YUM repository, and then download
   and install RabbitMQ 3.6.0 using the `rpm` utility:

   ~~~ shell
   sudo rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
   sudo rpm -Uvh http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.0/rabbitmq-server-3.6.0-1.noarch.rpm
   ~~~

### Install RabbitMQ using YUM

The RabbitMQ website provides [instructions for installing from the official
RabbitMQ YUM repository][rabbitmq-install].

_WARNING: this installation method is not recommended for Sensu Enterprise
users, as the repository is labeled as a "testing" repo, because (according to
the RabbitMQ website) "[they] release somewhat frequently", and there shouldn't
be a reason to upgrade RabbitMQ versions frequently._

## Managing the RabbitMQ service/process

1. Install the RabbitMQ init scripts using the [`chkconfig` utility][chkconfig]:

   ~~~ shell
   sudo chkconfig rabbitmq-server on
   ~~~

2. Start and stop the RabbitMQ service using the installed init scripts:

   ~~~ shell
   sudo /etc/init.d/rabbitmq-server start
   sudo /etc/init.d/rabbitmq-server stop
   ~~~

## Configure RabbitMQ access controls

Access to RabbitMQ is restricted by [access controls](rabbitmq-acl) (e.g.
username/password). For Sensu services to connect to RabbitMQ a RabbitMQ virtual
host (`vhost`) and user credentials will need to be created.

### Create a dedicated RabbitMQ `vhost` for Sensu

~~~ shell
sudo rabbitmqctl add_vhost /sensu
~~~

### Create a RabbitMQ user for Sensu

~~~ shell
sudo rabbitmqctl add_user sensu secret
sudo rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"
~~~

## Configuring system limits on Linux

Source: [rabbitmq.com][rabbitmq-install]

RabbitMQ installations running production workloads may need system limits and
kernel parameters tuning in order to handle a decent number of concurrent
connections and queues. The main setting that needs adjustment is the max number
of open files, also known as `ulimit -n`. The default value on many operating
systems is too low for a messaging broker (eg. 1024 on several Linux
distributions). We recommend allowing for at least 65536 file descriptors for
user `rabbitmq` in production environments. 4096 should be sufficient for most
development workloads.

There are two limits in play: the maximum number of open files the OS kernel
allows (`fs.file-max`) and the per-user limit (`ulimit -n`). The former must be
higher than the latter.

The most straightforward way to adjust the per-user limit for RabbitMQ is to
edit the [`rabbitmq-env.conf`][rabbitmq-config] to invoke `ulimit` before the
service is started.

~~~ shell
ulimit -S -n 4096
~~~

This soft limit cannot go higher than the hard limit (which defaults to 4096 in
many distributions). [The hard limit can be increased][basho-ulimit] via
`/etc/security/limits.conf`. This also requires enabling the
[`pam_limits.so`][http://askubuntu.com/a/34559] module and re-login or reboot.

Note that limits cannot be changed for running OS processes.

For more information about controlling `fs.file-max` with sysctl, please refer
to the [excellent Riak guide on open file limit tuning][basho-ulimit].

### Verifying the Limit

RabbitMQ management UI displays the number of file descriptors available for it
to use on the Overview tab.

~~~ shell
rabbitmqctl status
~~~

includes the same value. The following command:

~~~ shell
cat /proc/$RABBITMQ_BEAM_PROCESS_PID/limits
~~~

can be used to display effective limits of a running process.
`$RABBITMQ_BEAM_PROCESS_PID` is the OS PID of the Erlang VM running RabbitMQ, as
returned by <kbd>rabbitmqctl status</kbd>.


[erlang]:             https://www.erlang.org/
[rabbitmq-install]:   http://www.rabbitmq.com/install-rpm.html
[rabbitmq-acl]:       https://www.rabbitmq.com/access-control.html
[rabbitmq-erlang]:    https://www.rabbitmq.com/which-erlang.html
[rabbitmq-config]:    http://www.rabbitmq.com/configure.html
[chkconfig]:          https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/s2-services-chkconfig.html
[support]:            https://sensuapp.org/support
[basho-ulimit]:       http://docs.basho.com/riak/latest/ops/tuning/open-files-limit/#Linux
