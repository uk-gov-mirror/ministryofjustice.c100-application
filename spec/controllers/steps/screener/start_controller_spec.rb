require 'rails_helper'

RSpec.describe Steps::Screener::StartController, type: :controller do
  describe '#show' do
    it 'responds with HTTP success' do
      get :show
      expect(response).to be_successful
    end

    it 'resets the c100_application session data' do
      expect(session).to receive(:delete).with(:c100_application_id).ordered
      expect(session).to receive(:delete).with(:last_seen).ordered
      expect(session).to receive(:delete) # any other deletes
      get :show
    end
  end
end
