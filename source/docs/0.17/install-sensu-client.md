---
version: 0.17
category: "Installation Guide"
title: "Install Sensu Client"
next:
  url: "install-a-dashboard"
  text: "Install a Dashboard"
info:
warning:
danger:
---

Download an example Sensu check plugin:

~~~ shell
wget -O /etc/sensu/plugins/check-mem.sh http://sensuapp.org/docs/0.17/files/check-mem.sh
chown sensu:sensu /etc/sensu/plugins/check-mem.sh
chmod +x /etc/sensu/plugins/check-mem.sh
~~~
