require 'rails_helper'

RSpec.describe Steps::Petition::PlaybackController, type: :controller do
  it_behaves_like 'a show step controller'

  describe '#show' do
    let(:c100_application) { instance_double(C100Application) }

    before do
      allow(controller).to receive(:current_c100_application).and_return(c100_application)
      allow(controller).to receive(:update_navigation_stack)
    end

    it 'assigns the presenter' do
      expect(PetitionPresenter).to receive(:new).with(c100_application).and_call_original

      get :show

      expect(response).to render_template(:show)
      expect(assigns[:petition]).to be_a(PetitionPresenter)
    end
  end
end
