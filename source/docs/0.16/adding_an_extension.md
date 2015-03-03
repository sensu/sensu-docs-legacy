---
version: "0.16"
category: "Getting Started"
title: "Adding an extension"
---

# Adding a Sensu extension {#adding-a-sensu-extension}

Extensions are described in [Sensu extensions](extensions).

The most common extension type is "handler" which runs within the
Sensu server and behaves similarly to a normal handler.

There is a growing list of extensions available in the
[sensu-community-plugins](https://github.com/sensu/sensu-community-plugins/tree/master/extensions)
repo, including HipChat, FlapJack, Graphite, etc.

## Loading the extension {#loading-the-extension}

For purposes of illustration we'll use the community
[HipChat extension](https://github.com/sensu/sensu-community-plugins/blob/master/extensions/handlers/hipchat.rb).
It's a "handler" extension and thus runs on the sensu-server nodes.

On the server nodes we need to load the extensions 
in `/etc/sensu/config.json` or any JSON file in `/etc/sensu/conf.d`.

There are three parameters for doing this, use the one best suited to your needs.

~~~ json
{
  "extension_file": "/etc/sensu/extensions/hipchat.rb",

  "extension_dir": "/etc/sensu/extensions",

  "extension_dirs": [
    "/etc/sensu/extensions",
    ...
  ]
}
~~~

## Configuring the extension {#configuring-the-extension}

Before we can use the extension, we need to setup the parameters in
`/etc/sensu/conf.d/hipchat.json`

~~~ json
{
  "hipchat": {
    "apiversion": "v2",
    "room": "room api id number",
    "room_api_token": "room notification token",
    "from": "Sensu"
  }
}
~~~

## Adding the extension to a check {#adding-the-extension-to-a-check}

We will also need to update our check definition and connect it to the
new extension. Edit the `/etc/sensu/conf.d/check_cron.json` file from [adding a check](adding_a_check), on the sensu-server and modify the "handlers" attribute:

~~~ json
{
  "checks": {
    "cron_check": {
      "handlers": ["default", "hipchat"],
 ...
~~~

## Restarting Sensu {#restarting-sensu}

Restart sensu-client and sensu-server on the nodes and then stop the
crond daemon again. In a few minutes we should see a notification in HipChat
with the subject "Sensu" and a message about the problem.
