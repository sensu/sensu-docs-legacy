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
Sensu community plugins are currently in transition to more robust way of distribution. We want to package each
plugin as a part of bigger bundle of similar checks cover it with tests, release as a gem version. That requires
a lot of love from developers and you can help us to build a framework to automate the process of testing our
plugins.

**Expected outcome:**

We expect to have a set of tools written in Ruby which will allow us to:

* Improve existing set of tools [GIR][3] Make use of [sensu base plugin][1] and [plugin test scaffold][2]
  to setup toolkit which will allow to generate a new check which will be ready to be tested and proposed to community
* Create a testing framework which will allow to run a set of tests within virtual machines and report back the status
  of that process

[1]: https://github.com/sensu/sensu-plugin
[2]: https://github.com/sensu/sensu-plugin-spec
[3]: https://github.com/sensu-plugins/GIR

### 2 General refactoring of community plugins code base
**Brief explanation:**

This is a huge task but in a nutshell each repo should be looked at as a self sustaining entity. All the binaries in it should be broken down into libraries and any common code should be shared. All code should be Ruby, no shell or python. New stuff can/will still be accepted in any language but existing stuff should be converted or dropped.
This is my major pain point and I would be able to mentor on this as IO am already doing it whenever I get the chance.

**Expected outcome:**

...

**Knowledge prerequisite:**

...
