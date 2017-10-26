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

## Replace legacy string values

Most of the code which was specific to tax tribs has been
removed, however there are some leftover strings which will
need to be searched for and replaced, once the name of the new
service and its core data model have been chosen. These include:

* tribunal_case
* TribunalCase
* TaxTribs
* tax_tribs
* TaxTribunalsDatacapture
* Appeal to the tax tribunal

Some of these may also be present as file or directory names.

[taxtribs]: https://github.com/ministryofjustice/tax-tribunals-datacapture
[heroku-demo]: https://c100-demo.herokuapp.com
