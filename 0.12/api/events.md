---
layout: default
title: events
description: The Sensu API
version: '0.11'
---

<div class="page-header">
  <h1>Events API Endpoints<small></small></h1>
</div>

The event endpoints allows you to list and resolve events.

## `/events`

example url - http://localhost:4567/events

* `GET`: returns the list of current events

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

example url - http://localhost:4567/events/client_1

* `GET`: returns the list of current events for a client

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

example url - http://localhost:4567/events/client_1/check_chef_client

* `GET`: returns an event

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

  - success: 202

  - missing: 404

  - error: 500

## `/resolve`

example url - http://localhost:4567/resolve

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
