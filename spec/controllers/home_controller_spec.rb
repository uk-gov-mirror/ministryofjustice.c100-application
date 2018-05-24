require 'rails_helper'

RSpec.describe HomeController do
  describe '#miam_exemptions' do
    it 'renders the expected page' do
      get :miam_exemptions
      expect(response).to render_template(:miam_exemptions)
    end
  end
end
