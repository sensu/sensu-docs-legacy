---
layout: default
title: Sensu packages
description: Sensu packages
version: 0.9
---

# Sensu Packages

"Monolithic" Packages
------------------
The Sensu project provides "monolithic" packages which require no other dependencies. They are self-contained and include almost everything Sensu needs to function, including its own build of Ruby, all installed in `/opt/sensu`. This ensures the simplest installation process, promotes consistency across installs, and prevents Sensu from interfering with other Ruby applications.

Choose either the main or unstable repos, don't use both at the same time.

The repositories are browseable: http://repos.sensuapp.org/index.html (index.html is important)

Apt
---------------------
Tested on:

* Ubuntu 10.04, 11.04, 11.10, 12.04 
* Debian 6

Install the repo's pubkey:
```
wget -q http://repos.sensuapp.org/apt/pubkey.gpg -O- | sudo apt-key add -
```

main (stable) repo

```
deb     http://repos.sensuapp.org/apt sensu main
```

unstable repo (cutting edge, beta, nightlies)

```
deb     http://repos.sensuapp.org/apt sensu unstable
```

Yum 
---------------------
Tested on:

* CentOS (RHEL) 5, 6

main (stable) repo

```
[sensu]
name=sensu-main
baseurl=http://repos.sensuapp.org/yum/el/$releasever/$basearch/
gpgcheck=0
enabled=1
```

unstable repo (cutting edge, beta, nightlies)

```
[sensu-unstable]
name=sensu-unstable
baseurl=http://repos.sensuapp.org/yum-unstable/el/$releasever/$basearch/
gpgcheck=0
enabled=1
```

Valid values of `$releasever` are `5` and `6`.

If you get a 404 (such as if your `$releasever` expands to `5Server`), hardcode the value to 5 or 6.
