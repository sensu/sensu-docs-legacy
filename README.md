![sensu docs](https://raw.github.com/sensu/sensu/master/sensu-logo.png)

Documentation for the Sensu monitoring framework.

## Run
```
bundle install
bundle exec rake server
```

## Deploying to Heroku

```
bundle install
heroku create -s cedar --buildpack http://github.com/mattmanning/heroku-buildpack-ruby-jekyll.git
git push heroku master
```

## License
The Sensu Documentation is released under the [MIT
license](https://raw.github.com/sensu/sensu-docs/master/MIT-LICENSE.txt).

