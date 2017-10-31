# Family Justice C100 Service

[![Build
Status](https://travis-ci.org/ministryofjustice/c100-application.svg?branch=master)](https://travis-ci.org/ministryofjustice/c100-application)

Work in progress: This is a Rails application to enable citizens
to complete the C100 form. It is based on software patterns developed for the
[Appeal to the Tax Tribunal][taxtribs] application.

## Heroku demo.

There is a demo app. running on Heroku at [this url][heroku-demo]

The demo. app. uses http basic auth. to restrict access. The username and
password should be available from the MoJ Rattic server, in the Family Justice group.

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


[taxtribs]: https://github.com/ministryofjustice/tax-tribunals-datacapture
[heroku-demo]: https://c100-demo.herokuapp.com
