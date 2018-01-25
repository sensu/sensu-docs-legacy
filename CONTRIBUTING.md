# Contributing

**NOTE:** This repository is deprecated and no longer maintained by our community. We're keeping it here for historical purposes and access to legacy Sensu documentation (< 0.29). The most up-to-date documentation for the Sensu project is available at [sensu/sensu-docs](https://github.com/sensu/sensu-docs). If you're running a version of Sensu considered legacy, please upgrade (and talk [to the community](http://slack.sensu.io) if you need help doing so)!

If you do need to contribute to this legacy repo, please follow the guidelines below.

## Guidelines

We ask that you keep the following guidelines in mind when planning your contribution:

* Whether your contribution is for a bug fix or a feature request, **create an [Issue](https://github.com/sensu/sensu-docs-legacy)** to let us know what you are thinking before you fix it. It helps us give a LGTM much faster (with fewer cases of saying no to a PR)
* **For bugs**, if you have already found a fix, feel free to submit a Pull Request referencing the Issue you created. Include the `Fixes #` syntax to link it to the issue you're addressing.
* **For feature requests**, we want to improve upon the library incrementally which means small changes at a time. In order to ensure your PR can be reviewed in a timely manner, please keep PRs small. If you think this is unrealistic, then mention that within the issue and we can discuss it.

## Workflow

Once you're ready to contribute code back to this repo, ensure you setup your environment to be prepared for upstream contributions.

### 1) Fork on GitHub

Fork the appropriate repository by clicking the Fork button (top right) on GitHub.

### 2) Create a Local Fork

From whatever directory you want to have this code, clone this repository and setup some sane defaults:

```
$ git clone https://github.com/sensu/sensu-docs-legacy
# or: git clone git@github.com:$user/sensu-docs-legacy.git

$ cd sensu-docs-legacy

$ git remote add upstream https://github.com/sensu-plugins/sensu-docs-legacy.git
# or: git remote add upstream git@github.com:sensu-plugins/sensu-docs-legacy.git

# Never allow a push to upstream master
$ git remote set-url --push upstream no_push

# Confirm that your remotes make sense:
$ git remote -v
```

### 3) Create a Branch for Your Contribution

Begin by updating your local fork of the plugin:

```
$ git fetch upstream
$ git checkout master
$ git rebase upstream/master
```

Create a new, descriptively named branch to contain your change:

```
$ git checkout -b feature/myfeature
```

Now hack away at your awesome feature on the `feature/myfeature` branch.

### 4) Testing Your Code

There is not yet a standardization on how we test plugins across Sensu Community contributions. If you'd like to be part of the solution, [comment on this open Issue](https://github.com/sensu-plugins/community/issues/46). For now, please run your code on Sensu and ensure it works as expected.

### 5) Committing Code

Commit your changes with a thoughtful commit message.

```
$ git commit -am "Adding a check for Foo

Foo is a particularly helpful status when working with Bar. Designed to gather XYZ from the foobar interface."
```

Repeat the commit process as often as you need and then edit/test/repeat. Minor edits can be added to your last commit quite easily:

```
$ git add -u
$ git commit --amend
```

### 6) Pushing to GitHub

When ready to review (or just to establish an offsite backup or your work), push your branch to your fork on GitHub:

```
$ git push origin feature/myfeature
```

If you recently used `commit --amend`, you may need to force push:

```
$ git push -f origin feature/myfeature
```

### 7) Create a Pull Request

Create a pull request by visiting https://github.com/sensu-plugins/sensu-docs-legacy/ and following the instructions at the top of the screen.

After the PR is submitted, project maintainers will review it.

### 8) Responding to your Pull Request

PRs are rarely merged without some discussion with a maintainer. This is to ensure the larger Sensu community benefits from all code contributions.

They will use a system of labels, like `Status: Awaiting Response`, to indicate they need your feedback. Please regularly check your open PRs, easily found at https://github.com/pulls, to help maintainer's get the information needed to merge your code.

If you have questions or want to ensure a PR is reviewed, bring it up on the `#contributing` channel of [Sensu Community Slack](http://slack.sensu.io).

## Contributing Examples
One of the most helpful ways you can benefit the Sensu community is by writing about how you use Sensu. Write up something on [Medium](https://medium.com), embed Gists for longer code samples and let us know in Slack! We'll publish it to the blog at [blog.sensuapp.org](https://blog.sensuapp.org/).

## Contribute Elsewhere
This repository is one of **many** that are community supported around Sensu. See all the ways you can get involved by [visiting the Community repository](https://github.com/sensu-plugins/community#how-you-can-help).

## Thank You

We :heart: your participation and appreciate the unique perspective you bring to our community. Keep sharing in the #monitoringlove.
