---
version: "0.12"
category: "Installation"
title: "Windows"
---

### Installing a Windows Sensu client node

Installing and configuring a Sensu client on Windows is very different from the steps above.

#### Install Sensu Client Package

To install the sensu-client package, follow the MSI install instructions on the [Packages](packages) page.

#### Create the Sensu Windows Service

Use the Windows SC command to create the service.

``` shell
sc \\HOSTNAME_OR_IP create sensu-client start= delayed-auto binPath= c:\opt\sensu\bin\sensu-client.exe DisplayName= "Sensu Client"
```

The space between the equals(=) and the value is required.

#### Create Directories for conf.d and ssl


It is recommended you use the default install directory C:\opt\sensu.  You can locate them elsewhere if you choose, just remember to modify your config files appropriately.

Create these directories with the Command Prompt or Windows Explorer.

``` cmd
C:\opt\sensu\conf.d
C:\opt\sensu\ssl
```

#### Copy cert.pem and key.pem to C:\opt\sensu\ssl


These can be obtained from the Sensu server or from another Sensu client node (located in /etc/sensu/ssl/ by default).

#### Create the client config file at C:\opt\sensu\conf.d\config.json


``` json
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
```

Be sure to change the port and vhost values if you are not using the defaults.

#### Create C:\opt\sensu\conf.d\client.json


``` json
    {
      "client": {
        "name": "CLIENT_NODE_NAME",
        "address": "CLIENT_IP_ADDRESS",
        "subscriptions": [
          "SUBSCRIPTION_NAME"
        ]
      }
    }
```

#### Edit C:\opt\sensu\bin\sensu-client.xml


We need to add the -c and -d parameters to point to our newly created config files.

``` xml
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
```


#### Start the sensu-client service


Start the Sensu Client service from the Services.msc panel or from the Command Prompt.  Review the C:\opt\sensu\sensu-client.log for errors.
