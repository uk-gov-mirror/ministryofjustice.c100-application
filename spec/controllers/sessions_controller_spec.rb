require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe '#ping' do
    it 'does nothing and returns 204' do
      get :ping
      expect(response).to have_http_status(:no_content)
    end
  end

  describe '#destroy' do
    context 'when survey param is not provided' do
      it 'resets the application session' do
        expect(subject).to receive(:reset_c100_application_session)
        get :destroy
      end

      it 'redirects to the home page' do
        get :destroy
        expect(subject).to redirect_to(root_path)
      end
    end

    context 'when survey param is provided' do
      context 'for a `true` value' do
        it 'resets the session' do
          expect(subject).to receive(:reset_session)
          get :destroy, params: {survey: true}
        end

        it 'redirects to the survey page' do
          get :destroy, params: {survey: true}
          expect(response.location).to match(/surveymonkey.co.uk\/r\/NN8FJZ6$/)
        end
      end

      context 'for a `false` value' do
        it 'resets the application session' do
          expect(subject).to receive(:reset_c100_application_session)
          get :destroy, params: {survey: false}
        end

        it 'redirects to the home page' do
          get :destroy, params: {survey: false}
          expect(subject).to redirect_to(root_path)
        end
      end
    end

    context 'when a JSON request is made' do
      before { request.accept = "application/json" }

      it 'returns empty JSON and does not redirect' do
        expect(response.body).to be_empty
        expect(response.location).to be_nil
      end
    end
  end
end
