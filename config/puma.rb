threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count

port        ENV.fetch("PORT") { 3000 }

environment ENV.fetch("RAILS_ENV") { "development" }

plugin :tmp_restart

# Start Barnes to use Ruby Language Metrics on Heroku
# https://devcenter.heroku.com/articles/language-runtime-metrics-ruby
require 'barnes'
Barnes.start
