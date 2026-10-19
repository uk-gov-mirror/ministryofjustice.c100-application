# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require 'prometheus/middleware/exporter'

# The collector must wrap the exporter so `/metrics` itself is never recorded
# with a raw path. It labels requests by Rails route pattern, never by the
# literal URL, so secrets in paths are not disclosed on `/metrics`.
use PrometheusRouteCollector
use Prometheus::Middleware::Exporter

run Rails.application
Rails.application.load_server
