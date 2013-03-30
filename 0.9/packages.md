---
layout: default
title: Sensu packages
description: Sensu packages
version: 0.9
---

# Sensu Packages

The Sensu project provides "monolithic" or "omnibus" packages which require no other
dependencies. They are self-contained and include almost everything
Sensu needs to function, including its own build of Ruby, all installed
in `/opt/sensu`. This ensures the simplest installation process,
promotes consistency across installs, and prevents Sensu from
interfering with other Ruby applications.

Choose either the main or unstable repos, don't use both at the same time.

The repositories are browseable: [http://repos.sensuapp.org/index.html](http://repos.sensuapp.org/index.html)

## Apt

Tested on:

* Ubuntu 10.04, 11.04, 11.10, 12.04
* Debian 6

### Install the repo's pubkey:

{% highlight bash %}
    wget -q http://repos.sensuapp.org/apt/pubkey.gpg -O- | sudo apt-key add -
{% endhighlight %}

### Main (stable) repo

{% highlight bash %}
    deb     http://repos.sensuapp.org/apt sensu main
{% endhighlight %}

### Unstable repo (cutting edge, beta, nightlies)

{% highlight bash %}
    deb     http://repos.sensuapp.org/apt sensu unstable
{% endhighlight %}

## Yum

Tested on:

* CentOS (RHEL) 5, 6
* Fedora 15, 16, 17

### Main (stable) repo

{% highlight bash %}
    [sensu]
    name=sensu-main
    baseurl=http://repos.sensuapp.org/yum/el/$releasever/$basearch/
    gpgcheck=0
    enabled=1
{% endhighlight %}

## Unstable repo (cutting edge, beta, nightlies)

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

