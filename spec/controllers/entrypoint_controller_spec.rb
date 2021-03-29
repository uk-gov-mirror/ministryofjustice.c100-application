require 'rails_helper'

RSpec.describe EntrypointController do
  describe '#what_is_needed' do
    it 'renders the expected page' do
      get :what_is_needed
      expect(response).to render_template(:what_is_needed)
    end
  end
end
