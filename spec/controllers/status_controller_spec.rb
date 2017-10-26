require 'rails_helper'

RSpec.describe StatusController, type: :controller do
  let(:status) do
    {
      service_status: 'ok',
      version: 'ABC123',
      dependencies: {
          database_status: 'ok',
      }
    }.to_json
  end

  before do
    # Stubbing GlimrApiClient does not work here for some reason Stubbing
    # GlimrApiClient does not work here for some reason that isn't clear.
    stub_request(:get, /status/).
      to_return(status: 200, body: { service_status: 'ok' }.to_json)
    expect(ActiveRecord::Base).to receive(:connection).and_return(double)
    allow_any_instance_of(C100App::Status).to receive(:version).and_return('ABC123')
  end

  # This is very-happy-path to ensure the controller responds.  The bulk of the
  # status is tested in spec/services/status_spec.rb.
  describe '#index' do
    specify do
      get :index, format: :json
      expect(response.status).to eq(200)
    end

    it 'returns json' do
      get :index, format: :json
      expect(response.body).to eq(status)
    end
  end
end
