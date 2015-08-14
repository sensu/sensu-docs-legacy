![sensu docs](https://raw.github.com/sensu/sensu/master/sensu-logo.png)

Documentation for the Sensu monitoring framework.

## Overview

All documentation is written in [Markdown][markdown]. To preview the documentation in your browser run the following:

~~~ shell
bundle install --path vendor/bundle
bundle exec middleman
~~~

Then go view the docs at [http://localhost:4567](http://localhost:4567) (which redirects to [http://localhost:4567/docs/](http://localhost:4567/docs/)). Edits to the documentation source files should cause the `middleman` server to reload so you can see your changes update live.

*NOTE:* _the middleman stuff was yanked from the http://sensuapp.org middleman project. An attempt was made to strip any/all styling and theme sources, as well as removal of any references to commercial support offerings. If any of that was left over and it offends you, please feel free to remove it and submit a pull request._

## Hosting

All documentation is hosted on the official Sensu website (http://sensuapp.org), which is a static site built with [Middleman][middleman], and hosted on [GitHub Pages][pages].

The important parts to familiarize yourself with for contributing to the Sensu documentation are the markdown renderer and syntax highlighting engines used to power http://sensuapp.org.

Markdown rendering is handled by [Kramdown][kramdown].

Syntax Highlighting is handled by [middleman-syntax][syntax], which uses [Rouge][rouge], which is a ruby-based syntax highlighting engine that is compatible with [Pygments][pygments] templates and supports things like "fenced code blocks" and language-specific syntax highlighting from Markdown.

## Metadata

Each page also contains some YAML "frontmatter" that is used to compile the navigation menus (etc) on http://sensuapp.org. There are three "required" properties to include - **version**, **category**, and **title**.

~~~ yaml
---
version: "0.12"
category: "overview"
title: "Sensu Overview"
---
~~~

In addition to these required properties, there are also some optional metadata properties which can be employed:

**User Guide / Next Steps**

Some portions of the documentation should be read like a guide, prompting you on to the next step in the process. So, when present the "next" property will cause a prompt to appear at the bottom of the documentation page on http://sensuapp.org to guide the reader to the next relevant topic. If this property is missing (or if the corresponding "url" + "text" properties are omitted), no such prompt will appear.

~~~ yaml
---
version: "0.12"
category: "overview"
title: "Sensu Overview"
next:
  url: installing_sensu
  text: "Install Sensu"
---
~~~

**Banners**

Sometimes it is helpful to alert the reader to changes, warn them of common pitfalls, or make it known that _there be dragons_. Adding a **alert**, **warning**, or **danger** property to the frontmatter will cause a corresponding blue, yellow, or red banner to be displayed at the top of the content section of the documentation page on http://sensuapp.org.

~~~ yaml
---
version: "0.12"
category: "API"
title: "Health"
alert: "Added in Sensu version 0.9.13+"
---
~~~

## New Release

To create documentation for a new Sensu release, copy the previous release directory, and find and replace any occurrence of the previous release. The following commands are an example of how this can be done.

~~~ shell
cp -r source/docs/0.17 source/docs/0.18
find source/docs/0.18 -type f -exec sed -i 's/0\.17/0\.18/g' {} \;
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

