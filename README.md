![sensu docs](https://raw.github.com/sensu/sensu/master/sensu-logo.png)

Documentation for the Sensu monitoring framework.

## Requirements

- Pygments must be installed for rendering code-highlighted blocks. http://pygments.org/
  `sudo pip install pygments`

## Run
```
bundle install
bundle exec rake server
```

## View

After doing the previous two steps, and once WEBrick is listening (defaults to
port 4000), simply point your web browser to localhost:4000 to view the
documentation.

## Deploying to Heroku

```
bundle install
heroku create -s cedar --buildpack http://github.com/mattmanning/heroku-buildpack-ruby-jekyll.git
git push heroku master
```

## License
The Sensu Documentation is released under the [MIT
license](https://raw.github.com/sensu/sensu-docs/master/MIT-LICENSE.txt).

