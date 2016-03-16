---
version: 0.22
category: "Windows Guide"
title: "Install Sensu MSI"
next:
  url: "windows-service-configuration"
  text: "Configure Sensu on Windows"
success: "<strong>NOTE:</strong> this is part 1 of 2 steps in the Sensu
  Windows Guide. For the best results, please make sure to follow the
  instructions carefully and complete all of the steps in each section before
  moving on."
---

# MSI Installer

Unlike linux-based operating systems which install software from package repositories using package management, software on Windows is _primarily_ installed via standalone installer packages (e.g. .msi or .exe files). Sensu Core is installed on Windows using a MSI package. Please note the following instructions for installing Sensu on Windows.

The following instructions will help you to:

- Download the Sensu Core MSI
- Install the Sensu Core MSI

## Download the Sensu Core MSI

The latest Sensu Core MSI may be downloaded from [https://core.sensuapp.com/msi/](https://core.sensuapp.com/msi/).

## Install the Sensu Core MSI

Double-click on the downloaded Sensu Core MSI to begin the installation process. Follow the installation prompts, to accept the [Sensu Core license](https://github.com/sensu/sensu/blob/master/MIT-LICENSE.txt) and the default installation options.

_NOTE: changing the default Sensu Core installation path (`C:\opt`) will lead to problems later in the Windows installation guide._
