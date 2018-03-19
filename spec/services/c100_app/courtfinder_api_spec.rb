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

  describe '#age_in_seconds' do
    context 'given a path' do
      let(:path){ '/my/path' }

      context 'that exists' do
        let(:file_stat){ double('stat', mtime: Time.now - 10.seconds) }
        before do
          allow(File).to receive(:stat).with(path).and_return(file_stat)
        end

        it 'returns the difference between its mtime and now' do
          expect(subject.send(:age_in_seconds, path)).to eq(10)
        end
      end
      context 'that does not exist' do
        before do
          allow(File).to receive(:stat).with(path).and_raise(Errno::ENOENT)
        end

        it 'raises an ENOENT error' do
          expect{ subject.send(:age_in_seconds, path) }.to raise_error(Errno::ENOENT)
        end
      end
    end
  end

  describe '#file_is_valid?' do
    let(:exists){ false }
    let(:age){ 10 }
    let(:path){ '/my/path' }

    before do
      allow(File).to receive(:exist?).with(path).and_return(exists)
      allow(subject).to receive(:age_in_seconds).with(path).and_return(age)
    end

    context 'when there is no file at the given path' do
      let(:exists){ false }
      it 'returns false' do
        expect(subject.send(:file_is_valid?, path, 20)).to eq(false)
      end
    end

    context 'when there is a file at the given path' do
      let(:exists){ true }

      context 'older than the given max age' do
        let(:max_age){ 10 }
        it 'returns false' do
          expect(subject.send(:file_is_valid?, path, max_age)).to eq(false)
        end
      end
      context 'younger than the given max age' do
        let(:max_age){ 100 }
        it 'returns true' do
          expect(subject.send(:file_is_valid?, path, max_age)).to eq(true)
        end
      end
    end

  end

  describe '#all' do
    let(:courts){ ['court 1', 'court 2'] }
    let(:cache_path){ described_class::LOCAL_JSON_CACHE }
    let(:mock_json_data){ {'courts' => courts} }
    let(:file_contents){ mock_json_data.to_json }
    let(:valid){ false }

    before do
      allow(subject).to receive(:file_is_valid?).and_return(valid)
      allow(File).to receive(:read).with(cache_path).and_return(file_contents)
      allow(subject).to receive(:download_all_courts_json_to).with(cache_path)
      allow(JSON).to receive(:parse).and_return( mock_json_data )
    end

    context 'given a :cache_ttl' do
      it 'passes it to file_is_valid?' do
        expect(subject).to receive(:file_is_valid?).with(cache_path, 1234).and_return(true)
        subject.all(cache_ttl: 1234)
      end
    end
    context 'given no :cache_ttl' do
      it 'passes 86400 to file_is_valid?' do
        expect(subject).to receive(:file_is_valid?).with(cache_path, 86400).and_return(true)
        subject.all
      end
    end

    context 'when there is no valid file in LOCAL_JSON_CACHE' do
      let(:valid){ false }

      it 'logs a debug message saying it is downloading the file' do
        expect(subject.logger).to receive(:debug).with("downloading courts.json to #{cache_path}")
        subject.all
      end

      it 'downloads the all-courts json to LOCAL_JSON_CACHE' do
        expect(subject).to receive(:download_all_courts_json_to).with(cache_path)
        subject.all
      end
    end
    context 'when there is a valid file in LOCAL_JSON_CACHE' do
      let(:valid){ true }

      it 'does not downloads the all-courts json to LOCAL_JSON_CACHE' do
        expect(subject).to_not receive(:download_all_courts_json_to).with(cache_path)
        subject.all
      end
    end

    it 'reads the file in LOCAL_JSON_CACHE' do
      expect(File).to receive(:read).with(cache_path).and_return(file_contents)
      subject.all
    end

    it 'parses the file contents as JSON' do
      expect(JSON).to receive(:parse).with(file_contents).and_return(mock_json_data)
      subject.all
    end

    it 'returns the courts key of the parsed JSON' do
      expect(subject.all).to eq(courts)
    end
  end

  describe '#court_url' do
    context 'given a slug' do
      it 'returns a string joining the API_ROOT, "/courts/" and the slug' do
        expect(subject.court_url('my-slug')).to eq("#{subject.class::API_ROOT}courts/my-slug")
      end
    end
  end

  describe '#download_all_courts_json_to' do
    let(:download){ double('download') }
    before do
      allow(subject).to receive(:open).and_return(download)
      allow(IO).to receive(:copy_stream)
    end

    context 'given a path' do
      it 'opens the all-courts JSON url' do
        expect(subject).to receive(:open).with(subject.class::ALL_COURTS_JSON_URL).and_return(download)
        subject.download_all_courts_json_to('/my/path')
      end

      it 'copies the download stream to the given path' do
        expect(IO).to receive(:copy_stream).with(download, '/my/path')
        subject.download_all_courts_json_to('/my/path')
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
