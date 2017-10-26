require 'rails_helper'

RSpec.describe HomeController do
  describe '#index' do
    it 'resets the application in the session' do
      expect(subject).to receive(:reset_c100_application_session)
      get :index
    end
  end

  describe '#contact' do
    it 'renders the expected page' do
      get :contact
      expect(response).to render_template(:contact)
    end
  end

  describe '#cookies' do
    it 'renders the expected page' do
      get :cookies
      expect(response).to render_template(:cookies)
    end
  end
end
