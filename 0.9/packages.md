---
layout: default
title: Sensu packages
description: Sensu packages
version: 0.9
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

{% highlight bash %}
    wget -q http://repos.sensuapp.org/apt/pubkey.gpg -O- | sudo apt-key add -
{% endhighlight %}

### Stable repository

{% highlight bash %}
    deb     http://repos.sensuapp.org/apt sensu main
{% endhighlight %}

### Unstable repository

{% highlight bash %}
    deb     http://repos.sensuapp.org/apt sensu unstable
{% endhighlight %}

## Installing on Red Hat and CentOS via Yum

Tested on:

* CentOS (RHEL) 5, 6
* Fedora 15, 16, 17

### Stable repository

{% highlight bash %}
    [sensu]
    name=sensu-main
    baseurl=http://repos.sensuapp.org/yum/el/$releasever/$basearch/
    gpgcheck=0
    enabled=1
{% endhighlight %}

### Unstable repository

{% highlight bash %}
    [sensu-unstable]
    name=sensu-unstable
    baseurl=http://repos.sensuapp.org/yum-unstable/el/$releasever/$basearch/
    gpgcheck=0
    enabled=1
{% endhighlight %}

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

### Use the Windows SC command to create the service

{% highlight bash %}
    sc \\HOSTNAME_OR_IP create sensu-client start= delayed-auto binPath= c:\opt\sensu\bin\sensu-client.exe DisplayName= "Sensu Client"    
{% endhighlight %}

The space between the equals(=) and the value is required.

### Create conf.d and ssl directories

It's recommended you use the default install directory C:\opt\sensu.  You can move them elsewhere if you choose, just remember to modify your config files appropriately.

Create these with the Command Prompt or Windows Explorer.

{% highlight bash %}
    C:\opt\sensu\conf.d
    C:\opt\sensu\ssl
{% endhighlight %}

### Copy cert.pem and key.pem to C:\opt\sensu\ssl

These can be obtained from the Sensu server or on another Sensu client node (located in /etc/sensu/ssl/ by default).

### Create C:\opt\sensu\config.json

{% highlight json %}
    {
      "rabbitmq": {
        "host": "SENSU_HOSTNAME",
        "port": 5671,
        "vhost": "/sensu",
        "user": "SENSU_USERNAME",
        "password": "SENSU_PASSWORD",
        "ssl": {
          "cert_chain_file": "/opt/sensu/ssl/cert.pem",
          "private_key_file": "/opt/sensu/ssl/key.pem"
        }
      }
    }    
{% endhighlight %}

Be sure to change the port and vhost values if you are not using the defaults.

### Create C:\opt\sensu\conf.d\client.json

{% highlight json %}
    {
      "client": {
        "name": "CLIENT_NODE_NAME",
        "address:": "CLIENT_IP_ADDRESS",
        "subscriptions": [
          "SUBSCRIPTION_NAME"  
        ]
      }
    }
{% endhighlight %}

# Edit C:\opt\sensu\bin\sensu-client.xml

We need to add the -c and -d parameters to point to our newly created config files.

{% highlight xml %}
	<!--
	  Windows service definition for Sensu
	-->
	<service>
	  <id>sensu-client</id>
	  <name>Sensu Client</name>
	  <description>This service runs a Sensu client</description>
	  <executable>C:\opt\sensu\embedded\bin\ruby</executable>
	  <arguments>C:\opt\sensu\embedded\bin\sensu-client -c C:\opt\sensu\config.json -d C:\opt\sensu\conf.d -l C:\opt\sensu\sensu-client.log</arguments>
	</service>
{% endhighlight %}


### Start the sensu-client service

Start from the Services panel or from the Command Prompt.  Review the C:\opt\sensu\sensu-client.log for errors.

### Setup Checks and Handlers

*TODO*
