# Family Justice C100 Service

[![CircleCI](https://circleci.com/gh/ministryofjustice/c100-application.svg?style=svg)](https://circleci.com/gh/ministryofjustice/c100-application)

This is a Rails application to enable citizens to complete the C100 form.  
It is based on software patterns developed for the [Appeal to the Tax Tribunal][taxtribs] application.

## Heroku demo environment (soon K8s cluster)

There is a demo app running on Heroku at [this url][heroku-staging]

The demo app uses http basic auth to restrict access. The username and
password should be available from the MoJ Rattic server, in the Family Justice group.

**This environment is due to be deprecated / decommissioned** and superseded by another demo environment 
in the new Cloud Platforms K8s cluster, [at this url][k8s-staging]

## Getting Started

* `bundle install`
* Copy `.env.example` to `.env` and replace with suitable values
* `bundle exec rails db:setup`
* `bundle exec rails db:migrate`
* `bundle exec rails server`

### For running the tests:

* Copy `.env.test.example` to `.env.test` and replace with suitable values if you expect to run the tests
* `RAILS_ENV=test bundle exec rails db:setup`
* `RAILS_ENV=test bundle exec rails db:migrate`
* `RAILS_ENV=test bundle exec rake`

## Cucumber features

The features can be run manually (these are not part of the default rake task) in any of these forms:

* `bundle exec cucumber features`
* `bundle exec cucumber features/screener.feature`
* `bundle exec cucumber features/screener.feature -t @happy_path`
* `bundle exec cucumber features/screener.feature -t @unhappy_path`

By default cucumber will start a local server on a random port, run features against that server, and kill the server once the features have finished.

If you want to point the features at another server (WARNING: NEVER PRODUCTION!), pass the environment variable CUCUMBER_URL (or set the value in your local `.env` file) when calling cucumber:

* `CUCUMBER_URL=http://server.com bundle exec cucumber features`

## Mutation testing

This project uses extensive mutation coverage, which makes the (mutation) tests take a long time to run, and can end up with the CI killing the build due to excessive job work time.

In order to make this a bit faster, by default in CI master branch and in local when run without any flags, the scope of mutant testing will be reduced to a few models, and a randomized small sample of classes in each of these groups: Form objects and Decision trees.

In PRs, the mutation will be `--since master` meaning only files changed will be tested with mutant. This is much faster than running a random sample and also should be more accurate and pick the classes that matter (the changed ones, if any).

However it is still possible to have full flexibility of what mutant runs in your local environment:

##### Run mutation on a specific file:
`RAILS_ENV=test bundle exec rake mutant C100App::OtherPartiesDecisionTree`

##### Run mutation on the whole project (no random samples):
`RAILS_ENV=test bundle exec rake mutant all`

##### Run mutation on the whole project but only on files changed since master:
`RAILS_ENV=test bundle exec rake mutant master`

##### Run mutation on a small sample of classes (default):
`RAILS_ENV=test bundle exec rake mutant`


## CircleCI and continuous deployment

CircleCI is used for CI and CD and you can find the configuration in `.circleci/config.yml`  
After a successful build, a docker image will be created and pushed to an ECR repository.  

To authenticate with ECR some ENV variables need to be set in the CircleCI project.  
More information about these variables can be found in the [Cloud Platforms documentation][cloud-docs].

[taxtribs]: https://github.com/ministryofjustice/tax-tribunals-datacapture
[heroku-staging]: https://c100-staging.herokuapp.com
[k8s-staging]: https://c100-application-staging.apps.cloud-platform-live-0.k8s.integration.dsd.io
[cloud-docs]: https://ministryofjustice.github.io/cloud-platform-user-docs/02-deploying-an-app/004-use-circleci-to-upgrade-app
