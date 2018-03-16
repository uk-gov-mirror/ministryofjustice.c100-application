require 'rails_helper'

RSpec.describe StatusController, type: :controller do
  let(:status) do
    {
      service_status: 'ok',
      version: 'ABC123',
      dependencies: {
          database_status: 'ok',
          courtfinder_status: 'ok'
      }
    }.to_json
  end

  before do
    allow_any_instance_of(C100App::Status).to receive(:check).and_return(status)
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
