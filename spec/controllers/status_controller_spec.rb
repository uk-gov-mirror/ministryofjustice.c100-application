require 'rails_helper'

RSpec.describe StatusController, type: :controller do
  let(:status) { instance_double(C100App::Status, result: result, success?: success) }

  let(:result) {
    {
      service_status: 'ok',
      version: 'ABC123',
      dependencies: {
        database_status: 'ok',
        courtfinder_status: 'ok'
      }
    }.to_json
  }

  before do
    allow(C100App::Status).to receive(:new).and_return(status)
  end

  # This is very-happy-path to ensure the controller responds.  The bulk of the
  # status is tested in spec/services/status_spec.rb.
  describe '#index' do
    context 'for a healthy service' do
      let(:success) { true }

      it 'has a 200 response code' do
        get :index, format: :json
        expect(response.status).to eq(200)
      end

      it 'returns json' do
        get :index, format: :json
        expect(response.body).to eq(result)
      end
    end

    context 'for a non healthy service' do
      let(:success) { false }

      it 'has a 503 response code' do
        get :index, format: :json
        expect(response.status).to eq(503)
      end

      it 'returns json' do
        get :index, format: :json
        expect(response.body).to eq(result)
      end
    end
  end
end
