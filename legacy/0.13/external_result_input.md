---
version: "0.13"
category: "Advanced Topics"
title: "Inputting External Results to the Local Socket"
---

# Background

So far, two mechanisms to get Sensu events have been addressed:

* Checks defined and initiated by the Sensu client. (standalone: true).
* Checks defined on the *server*, that the clients '''subscribe''' to.
(subscribers: [ 'webservers' ])

There is a third way of getting Sensu event data onto the queue for Sensu
 handlers to consume: external results sent to the local socket on port 3030.

# Examples

~~~ shell
echo '{ "name": "my_check", "output": "some output", "status": 0 }' > /dev/tcp/localhost/3030
~~~

## Real Life Examples

* Joe Miller's [Pantheon Multi-Ping Check](https://gist.github.com/joemiller/5806570)
* Kyle Anderon's [Sensu Shell Helper](https://github.com/solarkennedy/sensu-shell-helper)

# Notes

* The client name associated with the event will be the client name of the 
 sensu-client process that is bound to localhost:3030.
* Attributes like event "action", "occurrences", and "issued" are set server-side, and 
 cannot be fed into the local socket.
* Any other user-provided event data *can* be for custom handlers to consume.
