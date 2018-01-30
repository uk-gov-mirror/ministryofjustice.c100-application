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
end