require 'rails_helper'

RSpec.describe CookiesController do
  describe '#edit' do
    it 'renders the expected page' do
      get :edit
      expect(response).to render_template(:edit)
    end
  end
end
