require 'rails_helper'

RSpec.describe HomeController do
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

  describe '#miam_exemptions' do
    it 'renders the expected page' do
      get :miam_exemptions
      expect(response).to render_template(:miam_exemptions)
    end
  end
end
