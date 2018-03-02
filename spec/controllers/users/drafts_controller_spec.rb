require 'rails_helper'

RSpec.describe Users::DraftsController, type: :controller do
  let(:user) { User.new }

  describe '#index' do
    context 'when user is logged out' do
      it 'redirects to the sign-in page' do
        get :index
        expect(response).to redirect_to(user_session_path)
      end
    end

    context 'when user is logged in' do
      before do
        sign_in(user)
      end

      it 'renders the drafts page' do
        get :index
        expect(assigns[:drafts]).not_to be_nil
        expect(response).to render_template(:index)
      end
    end
  end
end
