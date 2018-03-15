#!/bin/bash

set -euo pipefail

heroku config:set \
  EXTERNAL_URL=https://c100-staging.herokuapp.com \
  RACK_ENV=production \
  RAILS_ENV=production \
  RAILS_LOG_TO_STDOUT=enabled \
  RAILS_MAX_THREADS=3 \
  RAILS_SERVE_STATIC_FILES=enabled \
  SECRET_KEY_BASE=$(bundle exec rails secret) \
  GOVUK_NOTIFY_API_KEY=DUMMYVALUE \
  HTTP_AUTH_ENABLED=1 \
  HTTP_AUTH_USER=${HTTP_AUTH_USER} \
  HTTP_AUTH_PASSWORD=${HTTP_AUTH_PASSWORD} \
  LANG=en_US.UTF-8
