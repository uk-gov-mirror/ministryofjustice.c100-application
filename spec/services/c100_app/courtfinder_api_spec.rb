require 'rails_helper'

describe C100App::CourtfinderAPI do
  describe '#initialize' do
    context 'given arguments' do
      subject{ described_class.new(params) }
      context 'given a :logger' do
        let(:params){ {logger: double('logger') } }

        it 'stores the given logger' do
          expect(subject.logger).to eq(params[:logger])
        end
      end

      context 'given no :logger' do
        let(:params){ {} }

        it 'stores the Rails logger' do
          expect(subject.logger).to eq(Rails.logger)
        end
      end
    end

    context 'given no arguments' do
      it 'stores the Rails logger' do
        expect( described_class.new.logger ).to eq(Rails.logger)
      end
    end
  end

  describe '#court_for' do
    let(:dummy_json){ '[{"search": "result"}]' }
    before do
      allow(subject).to receive(:search).and_return(dummy_json)
    end

    it 'searches for the given area_of_law and postcode' do
      expect(subject).to receive(:search).with('area of law', 'given postcode')
      subject.court_for('area of law', 'given postcode')
    end

    it 'parses the returned data as JSON' do
      expect(subject.court_for('area of law', 'given postcode')).to eq( JSON.parse(dummy_json) )
    end

    context 'when an error is thrown' do
      let(:dummy_exception){ StandardError.new('test exception') }
      before do
        allow(subject).to receive(:search).and_raise(dummy_exception)
      end

      it 'handles the error' do
        expect(subject).to receive(:handle_error).with(dummy_exception)
        subject.court_for('a', 'b')
      end
    end
  end

  describe '#search' do
    let(:mock_response){ double('response', read: 'response body')}
    before do
      allow(subject).to receive(:open).and_return(mock_response)
    end

    it 'constructs a courtfinder search URL with the given postcode & area of law' do
      expect(subject).to receive(:construct_url).with('search/results', 'aol', 'pcd').and_return('the url')
      subject.search('aol', 'pcd')
    end

    context 'when the postcode has whitespace' do
      it 'strips all whitespace' do
        expect(subject).to receive(:construct_url).with('search/results', 'aol', 'mypcd')
        subject.search('aol', " my pcd\n")
      end
    end

    context 'when the postcode is mixed-case' do
      it "retains the mixed-case characters in the postcode" do
        expect(subject).to receive(:construct_url).with('search/results', 'aol', 'myPcD')
        subject.search('aol', "my PcD")
      end
    end

    it 'opens the constructed url' do
      allow(subject).to receive(:construct_url).with('search/results', 'aol', 'pcd').and_return 'constructed url'
      expect(subject).to receive(:open).with('constructed url').and_return(mock_response)
      subject.search('aol', 'pcd')
    end

    it 'returns the response' do
      expect(subject.search('aol', 'pcd')).to eq('response body')
    end
  end

  describe "#construct_url" do
    context 'given an endpoint, area_of_law and postcode' do
      let(:args){
        ['endpoint', 'aol', 'pcd']
      }

      it "returns the interpolated URL" do
        expect(subject.send(:construct_url,*args)).to include("endpoint.json?aol=aol&postcode=pcd")
      end
    end
  end

  describe "#handle_error" do
    let(:e){ double('exception') }

    it 'logs the error with the COURTFINDER_ERROR_MSG' do
      allow(subject).to receive(:raise)
      expect(subject).to receive(:log_error).with(C100App::CourtfinderAPI::COURTFINDER_ERROR_MSG, e)
      subject.send(:handle_error, e)
    end

    it 're-raises the error' do
      allow(subject).to receive(:log_error)
      expect(subject).to receive(:raise)
      subject.send(:handle_error, e)
    end
  end

  describe '#log_error' do
    let(:msg){ "blah" }
    let(:exception){ double('Exception') }
    before do
      allow(subject.logger).to receive(:info).with(anything)
      allow(Raven).to receive(:capture_exception)
    end

    it 'logs the message as info using its own logger' do
      expect(subject.logger).to receive(:info).with(msg)
      subject.send(:log_error, msg, exception)
    end

    it 'logs info about the exception using its own logger' do
      expect(subject.logger).to receive(:info).with({caller: 'C100App::CourtfinderAPI', method: 'court_for', error: exception}.to_json)
      subject.send(:log_error, msg, exception)
    end

    it 'captures the exception in Raven' do
      expect(Raven).to receive(:capture_exception).with(exception)
      subject.send(:log_error, msg, exception)
    end
  end

  describe '#court_url' do
    context 'given a slug' do
      it 'returns a string joining the API_ROOT, "/courts/" and the slug' do
        expect(subject.court_url('my-slug')).to eq("#{subject.class::API_ROOT}courts/my-slug")
      end

      context 'with a specific format' do
        it 'returns a url ending with the format' do
          expect(subject.court_url('my-slug', format: :json)).to end_with('my-slug.json')
        end
      end
    end
  end

  describe '#court_lookup' do
    let(:mock_io_stream) { double('io stream', read: '{"readresult": "value"}') }

    before do
      allow(subject).to receive(:court_url).and_return('my court url')
      allow(subject).to receive(:open).with('my court url').and_return(mock_io_stream)
    end

    it 'uses the memory store on envs that does not declare the `REDIS_URL` variable' do
      expect(subject.cache).to be_kind_of(ActiveSupport::Cache::MemoryStore)
    end

    context 'without cache' do
      before do
        subject.cache.clear
      end

      it 'gets the JSON court_url for the given slug' do
        expect(subject).to receive(:court_url).with('my-slug', format: :json).and_return('my court url')
        subject.court_lookup('my-slug')
      end

      it 'opens the court_url' do
        expect(subject).to receive(:open).with('my court url').and_return(mock_io_stream)
        subject.court_lookup('my-slug')
      end

      it 'returns the stream, read, parsed as JSON' do
        expect(subject.court_lookup('my-slug')).to eq({'readresult'=>'value'})
      end
    end

    context 'with cache' do
      it 'tries to fetch the key from the cache' do
        expect(subject.cache).to receive(:fetch).with(
          'my-slug', skip_nil: true, compress: false, expires_in: 72.hours, namespace: 'courtfinder'
        ).and_call_original

        subject.court_lookup('my-slug')
      end

      it 'calls the API when key is not found in the cache and stores it' do
        subject.cache.clear

        # first time, it calls the API
        expect(subject).to receive(:open).with('my court url').and_return(mock_io_stream)
        subject.court_lookup('my-slug')

        # second time, cache exists, do not call the API
        expect(subject).not_to receive(:open)
        subject.court_lookup('my-slug')
      end
    end
  end

  describe '#is_ok?' do
    context 'when status is "200"' do
      before do
        allow(subject).to receive(:status).and_return('200')
      end

      it 'returns true' do
        expect(subject.is_ok?).to eq(true)
      end
    end

    context 'when status is not "200"' do
      before do
        allow(subject).to receive(:status).and_return('400')
      end

      it 'returns false' do
        expect(subject.is_ok?).to eq(false)
      end

      context 'when status is not a string' do
        before do
          allow(subject).to receive(:status).and_return(200)
        end

        it 'returns false' do
          expect(subject.is_ok?).to eq(false)
        end
      end

    end

  end

  describe 'status' do
    let(:mock_response){ double(code: 'foo') }
    let(:http_object){ instance_double(Net::HTTP, request: mock_response) }
    let(:get_request){ instance_double(Net::HTTP::Get) }
    before do
      allow(subject).to receive(:http_object).and_return(http_object)
      allow(Net::HTTP::Get).to receive(:new).with('/healthcheck.json').and_return(get_request)
    end

    it 'makes a Net::HTTP::Get object passing /healthcheck.json' do
      expect(Net::HTTP::Get).to receive(:new).with('/healthcheck.json').and_return(get_request)
      subject.send(:status)
    end

    it 'makes a request on the http_object passing the healthcheck GET object' do
      expect(http_object).to receive(:request).with(get_request).and_return(mock_response)
      subject.send(:status)
    end

    it 'returns the status of the response' do
      expect(subject.send(:status)).to eq('foo')
    end
  end

  describe 'http_object' do
    let(:uri_port){ 80 }
    let(:uri){ double(URI, host: 'myhost', port: uri_port) }
    before do
      allow(subject).to receive(:api_root_uri).and_return(uri)
    end
    describe 'returned value' do
      let(:returned_value){ subject.send(:http_object) }

      it 'has address set to the host of api_root_uri' do
        expect( returned_value.address ).to eq( 'myhost' )
      end

      context 'when api_root_uri has port set to 443' do
        let(:uri_port){ 443 }

        it 'has use_ssl? set to true' do
          expect( returned_value.use_ssl? ).to eq(true)
        end
      end
      context 'when api_root_uri has port set to a non-integer' do
        let(:uri_port){ 443.0 }

        it 'has use_ssl? set to true' do
          expect( returned_value.use_ssl? ).to eq(true)
        end
      end

      context 'when api_root_uri has port not set to 443' do
        let(:uri_port){ 80 }

        it 'has use_ssl? set to false' do
          expect( returned_value.use_ssl? ).to eq(false)
        end
      end
    end
  end

  describe 'api_root_uri' do
    describe 'returned value' do
      let(:returned_value) { subject.send(:api_root_uri) }

      it 'is a URI' do
        expect(returned_value).to be_a(URI)
      end

      it 'has host set to the host of API_ROOT' do
        expect(returned_value.host).to eq(URI.parse(described_class::API_ROOT).host)
      end

      it 'has port set to 443' do
        expect(returned_value.port).to eq(443)
      end
    end
  end
end
