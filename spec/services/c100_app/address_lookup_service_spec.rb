require 'rails_helper'

RSpec.describe C100App::AddressLookupService do
  subject(:service) { described_class.new(postcode) }

  let(:query_params) do
    {
      key: 'test-token',
      postcode: postcode
    }
  end

  let(:api_request_uri) do
    uri = URI.parse(described_class::ORDNANCE_SURVEY_URL)
    uri.query = query_params.to_query
    uri
  end

  let(:postcode) { 'SW1H9AJ' }

  describe '#result' do
    before do
      allow(ENV).to receive(:fetch).with('ORDNANACE_SURVEY_API_KEY').and_return('test-token')
    end

    context 'when the lookup is successful' do
      let(:stubbed_json_body) { file_fixture('address_lookups/success.json') }

      before do
        stub_request(:get, api_request_uri)
          .to_return(status: 200, body: stubbed_json_body)
        service.result
      end

      context 'but the response does not contain any results' do
        let(:postcode) { 'W1A1AA' }
        let(:stubbed_json_body) { file_fixture('address_lookups/no_results.json') }

        it 'outcome is unsuccessful' do
          expect(service).not_to be_success
          expect(service.errors).to eq(lookup: [:no_results])
          expect(service.result).to eq([])
        end
      end

      it 'returns a list of mapped addresses' do
        expect(service).to be_success
        expect(service.errors).to be_empty
        expect(service.result).to all(be_an(C100App::MapAddressLookupResults::Address))
      end
    end

    context 'when there is a problem connecting to the postcode API' do
      before do
        stub_request(:get, api_request_uri)
          .to_raise(Errno::ECONNREFUSED)
        service.result
      end

      it 'outcome is unsuccessful' do
        expect(service).not_to be_success
        expect(service.errors).to eq(lookup: [:service_unavailable])
        expect(service.result).to eq([])
      end
    end

    context 'when the lookup service is not successful' do
      let(:stubbed_body) do
        {
          error: {
            statuscode: 400,
            message: 'No postcode parameter provided.'
          }
        }
      end

      before do
        stub_request(:get, api_request_uri)
          .to_return(status: 400, body: stubbed_body.to_json)
        service.result
      end

      it 'outcome is unsuccessful' do
        expect(service).not_to be_success
        expect(service.errors).to eq(lookup: [:unsuccessful])
        expect(service.result).to eq([])
      end
    end
  end
end
