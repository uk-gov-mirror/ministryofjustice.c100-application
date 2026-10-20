require 'rails_helper'
require 'prometheus/middleware/exporter'

RSpec.describe PrometheusRouteCollector do
  # Mirrors the middleware stack in `config.ru`, with an isolated registry.
  let(:registry) { Prometheus::Client::Registry.new }
  let(:exporter) { Prometheus::Middleware::Exporter.new(Rails.application, registry:) }
  let(:browser) { Rack::MockRequest.new(described_class.new(exporter, registry:)) }

  def metrics_body
    browser.get('/metrics').body
  end

  it 'records requests labelled by route pattern' do
    browser.get('/status')
    body = metrics_body

    expect(body).to match(%r{http_server_requests_total\{code="\d+",method="get",path="/status"\} 1})
    expect(body).to include('http_server_request_duration_seconds_count{method="get",path="/status"} 1')
    expect(body).not_to include('path="/metrics"')
  end

  it 'does not disclose download tokens on /metrics' do
    token = 'a' * 100
    browser.get("/download_tokens/#{token}")

    expect(metrics_body).to include('path="/download_tokens/:token"')
    expect(metrics_body).not_to include(token)
  end

  it 'collapses unknown paths into the catch-all route label' do
    browser.get('/AKIAIOSFODNN7EXAMPLE/junk-one')
    browser.get('/another/random/path')

    expect(metrics_body.scan(/path="([^"]+)"/).flatten.uniq).to eq(['/*path'])
  end

  it 'falls back to a fixed label when no route matches' do
    allow(Rails.application.routes.router).to receive(:recognize)
    browser.get('/no/route/here')

    expect(metrics_body).to include('path="/unmatched"')
  end
end
