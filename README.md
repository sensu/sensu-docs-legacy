![](https://raw.github.com/sensu/sensu/master/sensu-logo.png)

## Overview

This repository contains the documentation content for the Sensu monitoring
framework, including all legacy documentation and the latest documentation
content as hosted on the [Sensu documentation
website](https://sensuapp.org/docs).

All documentation is written in [Markdown][markdown].

## Hosting

All documentation is hosted on the official Sensu website (http://sensuapp.org),
which is a static site built with [Middleman][middleman], and hosted on [GitHub
Pages][pages].

The important parts to familiarize yourself with for contributing to the Sensu
documentation are the markdown renderer and syntax highlighting engines used to
power http://sensuapp.org.

* Markdown rendering is handled by [Kramdown][kramdown].

* Syntax Highlighting is handled by [middleman-syntax][syntax], which uses
  [Rouge][rouge], which is a ruby-based syntax highlighting engine that is
  compatible with [Pygments][pygments] templates and supports things like
  "fenced code blocks" and language-specific syntax highlighting from Markdown.

## Metadata

Each page also contains some YAML "frontmatter" that is used to compile the
navigation menus (etc) on http://sensuapp.org. There are three "required"
properties to include: **title**, **description**, **version**, and **weight**
(which controls the order the document appears in various tables of content).

~~~ yaml
---
title: "Client"
description: "Reference documentation for Sensu Clients."
version: "0.25"
weight: 2
---
~~~

In addition to these required properties, there are also some optional metadata
properties which can be employed:

**User Guide / Next Steps**

Some portions of the documentation should be read like a guide, prompting you on
to the next step in the process. So, when present the "next" property will cause
a prompt to appear at the bottom of the documentation page on
http://sensuapp.org to guide the reader to the next relevant topic. If this
property is missing (or if the corresponding "url" + "text" properties are
omitted), no such prompt will appear.

~~~ yaml
---
title: "Client"
description: "Reference documentation for Sensu Clients."
version: "0.26"
next:
  url: aggregates.html
  text: "Sensu Aggregates"
---
~~~

**Banners**

Sometimes it is helpful to alert the reader to changes, warn them of common
pitfalls, or make it known that _there be dragons_. Adding a `danger` (red),
`warning` (yellow), `info` (blue), and/or `success` (green) property to the
documentation frontmatter will cause a corresponding banner to be displayed at
the top of the content section of the documentation page on http://sensuapp.org.

~~~ yaml
---
title: "New Feature"
description: "Reference documentation for Sensu X"
version: "10.0"
info: "This feature is available in Sensu version 10.0 and newer."
---
~~~

## New Release

To create documentation for a new Sensu release, copy the previous release
directory, and find and replace any occurrence of the previous release. The
following commands are an example of how this can be done.

~~~ shell
cp -r source/docs/0.25 source/docs/0.26
find source/docs/0.26 -type f -exec sed -i '' 's/0\.25/0\.26/g' '{}' \;
~~~

## License
The Sensu Documentation is released under the
[MIT license][mit-license].


[markdown]: http://daringfireball.net/projects/markdown/syntax
[sensuapp]: http://sensuapp.org
[middleman]: http://middlemanapp.com
[pages]: http://pages.github.com/
[kramdown]: http://kramdown.gettalong.org/
[syntax]: https://github.com/middleman/middleman-syntax
[rouge]: https://github.com/jayferd/rouge
[pygments]: http://pygments.org/
[mit-license]: https://raw.github.com/sensu/sensu-docs/master/MIT-LICENSE.txt
