require 'rails_helper'

RSpec.describe Steps::Screener::StartController, type: :controller do
  before do
    expect(subject).to receive(:reset_c100_application_session)
  end

  describe '#show' do
    it 'responds with HTTP success' do
      get :show
      expect(response).to be_successful
    end
  end
end
