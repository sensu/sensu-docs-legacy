---
layout: default
title: checks
description: The Sensu API
version: '0.11'
---

<div class="page-header">
  <h1>Check API Endpoints<small></small></h1>
</div>

The check endpoints allow you to list and issue checks.

## `/checks`

example url - http://localhost:4567/checks

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

example url - http://localhost:4567/checks/check_chef_client

* `GET`: returns a check

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

example url - http://localhost:4567/check/request

* `POST`: issues a check request

  - payload:

             {
               "check": "check_chef_client",
               "subscribers": [
                 "chef-client"
               ]
             }

  - success: 202

  - malformed: 400

  - error: 500
