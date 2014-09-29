---
version: "0.14"
category: "Installation"
title: "Windows"
---

# Windows {#windows}

You can use Sensu to monitor Windows infrastructure.

Installation differs from Linux, however, much of the Sensu
[guide](guide) is still valid, with a few adjustments detailed on this
page.

## MSI package {#msi-package}

The Sensu project builds an omnibus [MSI package](packages) for
Windows users. By default, the package will install Sensu to
`C:\opt\sensu`, using this path is recommended, as it is consistent
with Linux systems.

## Configuration {#configuration}

You may follow the Sensu configuration steps for the "agent" system in
the [guide](guide), substituting the use of `/etc/sensu` with
`C:\etc\sensu`. Some directories may not exist, create these
directories with the Command Prompt or Windows Explorer.

## Create the Windows service {#create-the-windows-service}

Edit the Windows service definition for the Sensu client at
`C:\opt\sensu\bin\sensu-client.xml`.

Adding the configuration directory argument `-d`, setting it to
`C:\etc\sensu\conf.d`.

~~~ xml
  <!--
    Windows service definition for Sensu
  -->
  <service>
    <id>sensu-client</id>
    <name>Sensu Client</name>
    <description>This service runs a Sensu client</description>
    <executable>C:\opt\sensu\embedded\bin\ruby</executable>
    <arguments>C:\opt\sensu\embedded\bin\sensu-client -d C:\etc\sensu\conf.d -l C:\opt\sensu\sensu-client.log</arguments>
  </service>
~~~

Use the Windows SC command to create the service.

The space between the equals(=) and the values is required.

~~~ shell
sc \\HOSTNAME_OR_IP create sensu-client start= delayed-auto binPath= c:\opt\sensu\bin\sensu-client.exe DisplayName= "Sensu Client"
~~~

#### Start the service {#start-the-service}

Start the Sensu Client service from the Services.msc panel or the
Command Prompt.

Review the C:\opt\sensu\sensu-client.log for errors.
