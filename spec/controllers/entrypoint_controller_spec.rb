require 'rails_helper'

RSpec.describe EntrypointController do
  before do
    expect(subject).to receive(:reset_c100_application_session)
  end

  describe '#v1' do
    it 'renders the expected page' do
      get :v1
      expect(response).to render_template(:v1)
    end
  end

  describe '#v2' do
    it 'renders the expected page' do
      get :v2
      expect(response).to render_template(:v2)
    end
  end

  describe '#v3' do
    it 'renders the expected page' do
      get :v3
      expect(response).to render_template(:v3)
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
