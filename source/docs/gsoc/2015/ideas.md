---
title: "GSoC 2015 Ideas"
hide_toc: true
---

# GSoC 2015 Ideas

## Sensu Core
...

## Sensu Community Plugins

### 1 Automated testing framework built around Travis using standard Ruby methods, practices, and tools
**Brief explanation:**
Sensu community plugins are currently in transition to a more robust way of distribution. We want to package each
plugin as a part of bigger bundle of similar checks, cover it with tests, and then release as a gem version as part
of an automated process. That requires a lot of love from developers and you can help us to build a framework to
automate the process of testing our plugins.

**Expected outcome:**

We expect to have a set of tools written in Ruby which will allow us to:

* Improve existing set of tools [GIR][1]
  to setup toolkit which will allow to generate a new check which will be ready to be tested and proposed to community
* Create a testing framework which will allow us to run a set of tests within virtual machines and report back the
  status of that process

[1]: https://github.com/sensu-plugins/GIR

**Knowledge prerequisite:**

* general programing skills, should be functional in Ruby or be willing and able to be functional within a week
* general understanding of ruby test procedures (see above point)
* general concepts of monitoring or willingness to learn them
* general understanding of various testing tools including `rspec`, `rubocop`, and `serverspec`
* basic understanding of TravisCI
* basic understanding of infrastructure automation
* must believe and understand treating infrastructure as code and why this is necessary in a cloud environment


### 2 General refactoring of community plugins code base
**Brief explanation:**

This is a huge task but in a nutshell each repo should be looked at as a self sustaining entity.
All the binaries in it should be broken down into libraries and any common code should be shared.
All code should be Ruby, no shell or python. New stuff can/will still be accepted in any language but existing stuff
should be converted or dropped. This is my major pain point and I would be able to mentor on this as I am already doing
it whenever I get the chance.

**Expected outcome:**

* Code Climate > 2.0 on any repo that is being actively refactored
* No code duplication
* Standard Ruby coding practices
* Ephemeral data whenever needed, no traces let on a monitored system including temp files used to store state data
* Favor a pure ruby method, over a arch specific method even at the sacrifice of code complexity ie sys-filesystem gem vs `df`


**Knowledge prerequisite:**

* basic programing skills, should be functional in Ruby or be willing and able to be functional within a week
* general understanding of ruby std library (see above point)
* general concepts of monitoring or willingness to learn them
* general understanding of how to define, generate, and handle exit codes and what they mean within a sensu/nagios environment
* must believe and understand treating infrastructure as code and why this is necessary in a cloud environment
