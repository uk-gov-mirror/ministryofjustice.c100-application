require 'barnes'

workers_count = ENV.fetch("WEB_CONCURRENCY") { 2 }.to_i
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i

workers workers_count if Rails.env.production?
threads threads_count, threads_count

preload_app!

port        ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "development" }

plugin :tmp_restart

on_worker_boot do
  ActiveRecord::Base.establish_connection
  Barnes.start
end

on_restart do
  ActiveRecord::Base.connection.disconnect!
end

before_fork do
  require 'puma_worker_killer'

  PumaWorkerKiller.config do |config|
    config.ram = ENV.fetch("CONTAINER_AVAILABLE_RAM") { 512 }
    config.frequency = 15 # seconds
    config.percent_usage = 0.98
    config.rolling_restart_frequency = false
  end

  PumaWorkerKiller.start

  Barnes.start
end
