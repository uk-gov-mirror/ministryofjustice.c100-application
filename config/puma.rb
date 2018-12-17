workers_count = ENV.fetch("WEB_CONCURRENCY") { 2 }.to_i
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i

workers workers_count if ENV['RAILS_ENV'] == 'production'
threads threads_count, threads_count

preload_app!

port        ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "development" }

plugin :tmp_restart

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)
end

on_restart do
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)
end

before_fork do
  require 'puma_worker_killer'

  PumaWorkerKiller.config do |config|
    # Note: in Heroku, the available ram is not very accurate.
    # The env variable can be set higher to minimise this inaccuracy and
    # avoid killing the workers unnecessarily.
    config.ram = ENV.fetch("CONTAINER_AVAILABLE_RAM") { 512 }.to_i
    config.frequency = 30 # seconds
    config.percent_usage = 0.98
    config.reaper_status_logs = true
    config.rolling_restart_frequency = false
  end

  PumaWorkerKiller.start
end
