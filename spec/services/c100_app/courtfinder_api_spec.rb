require 'rails_helper'

describe C100App::CourtfinderAPI do
  let(:http_headers) { {
    'Accept' => 'application/json',
    'User-Agent' => 'child-arrangements-service',
  } }

  describe '.court_url' do
    it 'returns the court website URL' do
      expect(
        described_class.court_url('my-slug')
      ).to eq('https://courttribunalfinder.service.gov.uk/courts/my-slug')
    end
  end

  describe '#court_for' do
    before do
      # Mock it as we are not testing this now
      allow(Net::HTTP).to receive(:start)
    end

    it 'builds a GET request' do
      expect(
        Net::HTTP::Get
      ).to receive(:new).with(
        '/search/results.json?aol=Children&postcode=MK93DX', http_headers
      )

      subject.court_for('Children', 'MK93DX')
    end

    it 'sanitises the postcode and remove spaces' do
      expect(
        subject
      ).to receive(:get_request).with(
        '/search/results.json?aol=Children&postcode=MK93DX'
      )

      subject.court_for('Children', 'M-K 93 D$X')
    end

    # No need to repeat these tests with the other requests as all
    # are calling the same `#get_request` method and run the same code.
    context 'configuration of the http request' do
      let(:response_double) { {'foo' => 'bar'} }

      it 'configures the http client' do
        expect(
          Net::HTTP
        ).to receive(:start).with(
          'courttribunalfinder.service.gov.uk', 443, :ENV, { open_timeout: 10, read_timeout: 20, use_ssl: true }
        ).and_return(response_double)

        subject.court_for('Children', 'MK9 3DX')
      end

      context 'parse response body' do
        let(:http_double) { double('http_double') }
        let(:http_response) { double('http_response', body: '{"foo":"bar"}') }

        before do
          allow(
            Net::HTTP
          ).to receive(:start).and_yield(http_double)
        end

        it 'parses the JSON response body' do
          expect(http_double).to receive(:request).with(
            an_instance_of(Net::HTTP::Get)
          ).and_return(http_response)

          expect(
            subject.court_for('Children', 'MK9 3DX')
          ).to eq({'foo' => 'bar'})
        end
      end
    end

    context 'when an error is thrown' do
      let(:dummy_exception){ StandardError.new('test exception') }

      before do
        allow(Net::HTTP).to receive(:start).and_raise(dummy_exception)
      end

      it 'reports the error to Sentry and re-raise it' do
        expect(Raven).to receive(:capture_exception).with(dummy_exception)

        expect {
          subject.court_for('a', 'b')
        }.to raise_error(dummy_exception)
      end
    end
  end

  describe '#court_lookup' do
    before do
      # Mock it as we are not testing this now
      allow(Net::HTTP).to receive(:start)
    end

    it 'uses the memory store on envs that does not declare the `REDIS_URL` variable' do
      expect(subject.cache).to be_kind_of(ActiveSupport::Cache::MemoryStore)
    end

    it 'builds a GET request' do
      expect(
        Net::HTTP::Get
      ).to receive(:new).with(
        '/courts/my-slug.json', http_headers
      )

      subject.court_lookup('my-slug')
    end

    context 'without cache' do
      before do
        subject.cache.clear
      end

      it 'request the court json' do
        expect(subject).to receive(:get_request).with('/courts/my-slug.json')
        subject.court_lookup('my-slug')
      end

      context 'when an error is thrown' do
        let(:dummy_exception){ StandardError.new('test exception') }

        before do
          allow(Net::HTTP).to receive(:start).and_raise(dummy_exception)
        end

        it 'reports the error to Sentry and re-raise it' do
          expect(Raven).to receive(:capture_exception).with(dummy_exception)

          expect {
            subject.court_lookup('my-slug')
          }.to raise_error(dummy_exception)
        end
      end
    end

    context 'with cache' do
      it 'tries to fetch the key from the cache' do
        expect(subject.cache).to receive(:fetch).with(
          'my-slug', skip_nil: true, compress: false, expires_in: 72.hours, namespace: 'courtfinder'
        )

        subject.court_lookup('my-slug')
      end

      it 'calls the API when key is not found in the cache and stores it' do
        subject.cache.clear

        # first time, it calls the API
        expect(subject).to receive(:get_request).with('/courts/my-slug.json')
        subject.court_lookup('my-slug')

        # second time, cache exists, do not call the API
        expect(subject).not_to receive(:get_request)
        subject.court_lookup('my-slug')
      end
    end
  end

  describe '#is_ok?' do
    let(:healthy_response) { { '*' => { 'status' => true } } }
    let(:unhealthy_response) { { '*' => { 'status' => false } } }

    before do
      # Mock it as we are not testing this now
      allow(Net::HTTP).to receive(:start)
    end

    it 'builds a GET request' do
      expect(
        Net::HTTP::Get
      ).to receive(:new).with(
        '/healthcheck.json', http_headers
      )

      subject.is_ok?
    end

    context 'when service is healthy' do
      before do
        allow(subject).to receive(:get_request).and_return(healthy_response)
      end

      it 'returns true' do
        expect(subject.is_ok?).to eq(true)
      end

      # mutant kill
      it 'digs the status' do
        expect(healthy_response).to receive(:dig).with('*', 'status')
        subject.is_ok?
      end
    end

    context 'when service is unhealthy' do
      before do
        allow(subject).to receive(:get_request).and_return(unhealthy_response)
      end

      it 'returns false' do
        expect(subject.is_ok?).to eq(false)
      end
    end

    context 'when healthcheck request raised an error' do
      before do
        allow(Net::HTTP).to receive(:start).and_raise(StandardError)
      end

      it 'returns false' do
        expect(subject.is_ok?).to eq(false)
      end
    end
  end
end
