require 'rails_helper'

RSpec.describe C100App::NewCourtfinderApiToken do
  subject(:token_service) { described_class.new }

  let(:http) { instance_double(Net::HTTP) }
  let(:response) do
    Net::HTTPOK.new('1.1', '200', 'OK').tap do |res|
      allow(res).to receive(:body).and_return(
        {
          access_token: 'new-access-token',
          expires_in: 3600
        }.to_json
      )
    end
  end

  before do
    allow(Sentry).to receive(:capture_message)
    allow(Sentry).to receive(:capture_exception)
  end

  describe '#token' do
    context 'when credentials already exist' do
      before do
        allow(token_service).to receive(:courtfinder_api_credentials).and_return(access_token: 'cached-token')
      end

      it 'returns the existing access token' do
        expect(token_service.token).to eq('cached-token')
      end

      it 'does not request a new token' do
        expect(token_service).not_to receive(:fetch_token)

        token_service.token
      end
    end

    context 'when credentials do not exist' do
      before do
        allow(token_service).to receive(:courtfinder_api_credentials).and_return(nil)
        allow(Net::HTTP).to receive(:start).and_yield(http)
        allow(http).to receive(:request).and_return(response)
        allow(token_service).to receive(:update_courtfinder_token)
      end

      it 'requests a new access token' do
        expect(token_service.token).to eq('new-access-token')
      end

      it 'sends a POST request to the token endpoint' do
        expect(http).to receive(:request) do |request|
          expect(request).to be_a(Net::HTTP::Post)
          expect(request['Accept']).to eq('application/json')
          expect(request['User-Agent']).to eq('child-arrangements-service')
          expect(request.body).to include('grant_type=client_credentials')
          expect(request.body).to include('client_id=')
          expect(request.body).to include('client_secret=')
          expect(request.body).to include('scope=')

          response
        end

        token_service.token
      end

      it 'stores the access token and expiry' do
        expect(token_service).to receive(:update_courtfinder_token).with('new-access-token', 3600)

        token_service.token
      end
    end

    context 'when the token response is unsuccessful' do
      let(:response) do
        Net::HTTPBadRequest.new('1.1', '400', 'Bad Request').tap do |res|
          allow(res).to receive(:body).and_return(
            { error: 'invalid_client' }.to_json
          )
        end
      end

      before do
        allow(token_service).to receive(:courtfinder_api_credentials).and_return(nil)
        allow(Net::HTTP).to receive(:start).and_yield(http)
        allow(http).to receive(:request).and_return(response)
      end

      it 'reports the failure to Sentry' do
        expect(Sentry).to receive(:capture_message).with('Court Finder token request failed: HTTP 400')
        expect(Sentry).to receive(:capture_exception).with(instance_of(KeyError))
        expect { token_service.token }.to raise_error(KeyError)
      end
    end

    context 'when the token request raises an exception' do
      before do
        allow(token_service).to receive(:courtfinder_api_credentials).and_return(nil)

        allow(Net::HTTP).to receive(:start).and_raise(StandardError, 'connection failed')
      end

      it 'reports the exception to Sentry and reraises it' do
        expect(Sentry).to receive(:capture_exception).with(instance_of(StandardError))

        expect { token_service.token }.to raise_error(StandardError, 'connection failed')
      end
    end
  end
end