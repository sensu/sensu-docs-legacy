---
layout: default
title: The Sensu API
description: The Sensu API
version: 0.9
---

# The Sensu API

The Sensu API provides access to the data Sensu servers collect, such as clients & events.

The API is capable of requesting checks be executed and can resolve events.

When using the Sensu packages, you may start the API on one or more boxes with `/etc/init.d/sensu-api start`.

## `/info`

* `GET`: returns the API info

  - success: 200:

                {
                    "rabbitmq": {
                        "connected": true,
                        "keepalives": {
                            "consumers": 1,
                            "messages": 0
                        },
                        "results": {
                            "consumers": 1,
                            "messages": 0
                        }
                    },
                    "redis": {
                        "connected": true
                    },
                    "sensu": {
                        "version": "0.9.11"
                    }
                }

  - error: 500

## `/clients`

* `GET`: returns the list of clients

  - success: 200:

             [
               {
                 "name": "client_1",
                 "address": "192.168.0.2",
                 "subscriptions": [
                   "chef-client",
                   "sensu-server"
                 ],
                 "timestamp": 1324674972
               },
               {
                 "name": "client_2",
                 "address": "192.168.0.3",
                 "subscriptions": [
                   "chef-client",
                   "webserver",
                   "memcached"
                 ],
                 "timestamp": 1324674956
               }
             ]

  - error: 500

## `/clients/:name`

* `GET`: returns a client

  example url - http://localhost:4567/clients/client_2

  - success: 200:

             {
               "name": "client_2",
               "address": "192.168.0.3",
               "subscriptions": [
                 "chef-client",
                 "webserver",
                 "memcached"
               ],
               "timestamp": 1324674956
             }

  - missing: 404

  - error: 500

* `DELETE`: removes a client, resolving its current events (delayed action)

  example url - http://localhost:4567/clients/client_2

  - success: 202

  - missing: 404

  - error: 500

## `/checks`

* `GET`: returns the list of checks

  - success: 200:

             [
               {
                 "name": "check_chef_client",
                 "command": "check-procs.rb -p /usr/bin/chef-client -W 1 -w 2 -c 3",
                 "subscribers": [
                   "chef-client"
                 ],
                 "interval": 60
               },
               {
                 "name": "check_web_stack",
                 "command": "check-http.rb -h localhost -p /health -P 80 -q Passed -t 30",
                 "subscribers": [
                   "webserver"
                 ],
                 "interval": 30
               }
             ]

  - error: 500

## `/checks/:name`

* `GET`: returns a check

  example url - http://localhost:4567/checks/check_chef_client

  - success: 200:

             {
               "name": "check_chef_client",
               "command": "check-procs.rb -p /usr/bin/chef-client -W 1 -w 2 -c 3",
               "subscribers": [
                 "chef-client"
               ],
               "interval": 60
             }

  - missing: 404

  - error: 500

## `/check/request`

* `POST`: issues a check request

  - payload:

             {
               "check": "check_chef_client",
               "subscribers": [
                 "chef-client"
               ]
             }

  - success: 201

  - malformed: 400

  - error: 500

## `/events`

* `GET`: returns the list of current events

  example url - http://localhost:4567/events

  - success: 200:

             [
               {
                 "client": "client_1",
                 "check": "check_chef_client",
                 "occurrences": 1,
                 "output": "CHEF CLIENT WARNING - Daemon is NOT running\n",
                 "status": 1,
                 "flapping": false
               },
               {
                 "client": "client_2",
                 "check": "check_web_stack",
                 "occurrences": 1,
                 "output": "WEB STACK CRITICAL - Apache is NOT responding\n",
                 "status": 2,
                 "flapping": false
               }
             ]

  - error: 500

## `/events/:client`

* `GET`: returns the list of current events for a client

  example url - http://localhost:4567/events/client_1

  - success: 200:

             [
               {
                 "client": "client_1",
                 "check": "check_chef_client",
                 "occurrences": 1,
                 "output": "CHEF CLIENT WARNING - Daemon is NOT running\n",
                 "flapping": false,
                 "status": 1
               }
             ]

  - error: 500

## `/events/:client/:check`

* `GET`: returns an event

  example url - http://localhost:4567/events/client_1/check_chef_client

  - success: 200:

             {
               "client": "client_1",
               "check": "check_chef_client",
               "occurrences": 1,
               "output": "CHEF CLIENT WARNING - Daemon is NOT running\n",
               "flapping": false,
               "status": 1
             }

  - missing: 404

  - error: 500

* `DELETE`: resolves an event (delayed action)

  example url - http://localhost:4567/events/client_1/check_chef_client

  - success: 202

  - missing: 404

  - error: 500

## `/event/resolve`

* `POST`: resolves an event (delayed action)

  - payload:

             {
               "client": "client_1",
               "check": "check_chef_client"
             }

  - success: 202

  - missing: 404

  - malformed: 400

  - error: 500

## `/stashes/:path`

* `POST`: create a stash (JSON document)

  example url - http://localhost:4567/stashes/foo

  - payload:

             {
               "bar": 42
             }

  - success: 201

  - malformed: 400

  - error: 500

* `GET`: get a stash (JSON document)

  example url - http://localhost:4567/stashes/foo

  - success: 200:

             {
               "bar": 42
             }

  - missing: 404

  - error: 500

* `DELETE`: delete a stash (JSON document)

  example url - http://localhost:4567/stashes/foo

  - success: 204

  - missing: 404

  - error: 500

## `/stashes`

* `GET`: returns a list of stash paths

  - success: 200:

             [
               "foo",
               "bar"
             ]

  - error: 500

* `POST`: returns multiple stashes (JSON documents)

  - payload:

             [
               "foo",
               "bar"
             ]

  - success: 200:

             {
               "foo": {
                 "bar": 42
               },
               "bar": {
                 "foo": 73
               }
             }

  - error: 500

