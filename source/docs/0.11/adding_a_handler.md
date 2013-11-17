---
version: "0.11"
category: "Getting Started"
title: "Adding a handler"
---

# Adding a Sensu handler

Handlers run on the Sensu server and receive the output generated from
checks executing on Sensu clients. They decide what to do with the data,
for example:

- Send an email
- Generate an alert
- Send an SMS
- Add metrics to graphite, etc.

Out of the box Sensu ships with a 'default' handler which does nothing
more than parse the JSON its fed via STDIN and spits back to STDOUT. A
sample JSON document for testing purposes is available here:
https://gist.github.com/1723079

There is a growing list of handlers available in the
[sensu-community-plugins](https://github.com/sensu/sensu-community-plugins/tree/master/handlers)
repo, including Pagerduty, IRC, Campfire, etc.

## Creating a handler
    
Let's create a simple handler that simply sends the raw check output to ourselves via email.

The most common handler type is "pipe" which tells Sensu to shell out
and run the specified command. We'll cover more handler types in the
future. On the server nodes, we will define our 'email' handler in
`/etc/sensu/conf.d/handler_email.json`.

``` json
{
  "handlers": {
    "email": {
      "type": "pipe",
      "command": "mail -s 'sensu alert' your@address"
    }
  }
}
```

## Adding the handler to a check

We will also need to update our check definition and connect it to the
new handler. Edit the `/etc/sensu/conf.d/check_cron.json` file on the
sensu-server and modify the "handlers" attribute:

``` json
{
  "checks": {
    "cron_check": {
      "handlers": ["default", "email"],
 ...
```

## Restarting Sensu

Restart sensu-client and sensu-server on the nodes and then stop the
crond daemon again. In a few minutes we should get an email from sensu
with the subject "sensu alert" and a bag full of JSON data.

This isn't the most useful handler but it illustrates the concepts of
checks and handlers and how they work together. At this point we now
have a working sensu-client and sensu-server to start experimenting
further.

## A real world example

Now let's experiment with a more complex handler.

On the sensu-server node, download the community mailer handler and
config from the
[sensu-community-plugins](https://github.com/sensu/sensu-community-plugins/tree/master/handlers)
repo :

    wget -O /etc/sensu/handlers/mailer.rb https://raw.github.com/sensu/sensu-community-plugins/master/handlers/notification/mailer.rb
    wget -O /etc/sensu/conf.d/mailer.json https://raw.github.com/sensu/sensu-community-plugins/master/handlers/notification/mailer.json

Adjust `/etc/sensu/conf.d/mailer.json` to fit your environment.

Define a new pipe handler, in `/etc/sensu/conf.d/handler_mailer.json`:

``` json
{
  "handlers": {
    "mailer": {
      "type": "pipe",
      "command": "/etc/sensu/handlers/mailer.rb"
    }
  }
}
```

And finally connect some check to the new handler, just like we did in
the first example. This time, the handler is named `mailer`.

``` json
{
  "checks": {
    "cron_check": {
      "handlers": ["default", "mailer"],
...
```

Restart sensu-server and trigger the check again. You should get an
email from the `mailer` handler.
