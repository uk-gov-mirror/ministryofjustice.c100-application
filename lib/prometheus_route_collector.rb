require 'prometheus/middleware/collector'

# Rack middleware that records Prometheus request metrics labelled by the
# matched Rails route pattern (for example `/download_tokens/:token`) rather
# than the raw request path.
#
# The stock collector only masks numeric ids and UUIDs, so secrets embedded in
# URLs (such as document download tokens) would otherwise end up as label
# values and be disclosed on `/metrics`. Using the route pattern keeps secrets
# out of the metrics and bounds label cardinality, as unknown paths all collapse
# into a single label.
class PrometheusRouteCollector < Prometheus::Middleware::Collector
  UNMATCHED_PATH = '/unmatched'.freeze
  FORMAT_SUFFIX = '(.:format)'.freeze

  protected

  def generate_path(env)
    request = ActionDispatch::Request.new(env.dup)

    Rails.application.routes.router.recognize(request) do |route, _params|
      return route.path.spec.to_s.delete_suffix(FORMAT_SUFFIX)
    end

    UNMATCHED_PATH
  end
end
