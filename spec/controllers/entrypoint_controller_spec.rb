require 'rails_helper'

RSpec.describe EntrypointController do
  describe '#v1' do
    it 'renders the expected page' do
      get :v1
      expect(response).to render_template(:v1)
    end
  end

  describe '#what_is_needed' do
    it 'renders the expected page' do
      get :what_is_needed
      expect(response).to render_template(:what_is_needed)
    end
  end

  describe '#how_long' do
    it 'renders the expected page' do
      get :how_long
      expect(response).to render_template(:how_long)
    end
  end
end
