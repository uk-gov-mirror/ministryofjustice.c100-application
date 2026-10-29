require 'rails_helper'

describe C100App::NewCourtfinderApi do
  subject(:api) { described_class.new(token: token) }

  let(:token) { instance_double(C100App::NewCourtfinderApiToken, token: 'test-token') }
  let(:http) { instance_double(Net::HTTP) }
  let(:response) do
    Net::HTTPOK.new('1.1', '200', 'OK').tap do |res|
      allow(res).to receive(:body).and_return('{"courts": []}')
    end
  end

  before do
    allow(Net::HTTP).to receive(:start).and_yield(http)
    allow(http).to receive(:request).and_return(response)
    allow(Sentry).to receive(:capture_message)
    allow(Sentry).to receive(:capture_exception)
  end

  describe '#court_for' do
    it 'sends a postcode search request with the correct parameters' do
      expect(http).to receive(:request) do |request|
        expect(request).to be_a(Net::HTTP::Get)
        expect(request.path).to include('/search/courts/v1/postcode?')
        expect(request.path).to include('postcode=SW1A+1AA')
        expect(request.path).to include('serviceArea=')
        expect(request.path).to include('action=NEAREST')
        expect(request['Authorization']).to eq('Bearer test-token')
        expect(request['Accept']).to eq('application/json')
        expect(request['User-Agent']).to eq('child-arrangements-service')
        response
      end

      result = api.court_for(
        'Childcare arrangements if you separate from your partner',
        'SW1A 1AA'
      )

      expect(result).to eq('courts' => [])
    end

    it 'normalises a postcode without a space' do
      expect(http).to receive(:request) do |request|
        expect(request.path).to include('postcode=SW1A+1AA')
        response
      end

      api.court_for('Childcare arrangements', 'SW1A1AA')
    end

    it 'returns the parsed JSON response' do
      expect(api.court_for('Childcare arrangements', 'SW1A 1AA')).to eq('courts' => [])
    end
  end

  describe '#court_lookup' do
    it 'requests a court by slug' do
      expect(http).to receive(:request) do |request|
        expect(request.path).to eq('/fact/courts/slug/london-family-court/v1')
        expect(request['Authorization']).to eq('Bearer test-token')
        response
      end

      expect(api.court_lookup('london-family-court'))
        .to eq('courts' => [])
    end
  end

  describe '#is_ok?' do
    it 'returns true when the API request succeeds' do
      expect(api.is_ok?).to be(true)
    end

    it 'returns false when the API request fails' do
      allow(http).to receive(:request).and_raise(StandardError, 'connection failed')

      expect(api.is_ok?).to be(false)
    end
  end

  describe 'HTTP failures' do
    let(:response) do
      Net::HTTPBadRequest.new('1.1', '400', 'Bad Request').tap do |res|
        allow(res).to receive(:body).and_return('{"error":"bad request"}')
      end
    end

    it 'reports the failure to Sentry and raises an error' do
      expect(Sentry).to receive(:capture_message).with(/Court Finder request failed: HTTP 400/)
      expect(Sentry).to receive(:capture_exception).with(instance_of(RuntimeError))
      expect { api.court_lookup('invalid-court') }.to raise_error(RuntimeError, /Court Finder request failed: HTTP 400/)
    end
  end

  describe 'connection errors' do
    before do
      allow(http).to receive(:request).and_raise(StandardError, 'connection failed')
    end

    it 'reports the exception to Sentry and reraises it' do
      expect(Sentry).to receive(:capture_exception).with(instance_of(StandardError))
      expect { api.court_lookup('london-family-court') }.to raise_error(StandardError, 'connection failed')
    end
  end
end