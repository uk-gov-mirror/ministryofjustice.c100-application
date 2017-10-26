require 'rails_helper'

RSpec.describe ApplicationController do
  controller do
    def invalid_session; raise Errors::InvalidSession; end
    def another_exception; raise Exception; end
  end

  context 'Exceptions handling' do
    before do
      allow(Rails).to receive_message_chain(:application, :config, :consider_all_requests_local).and_return(false)
    end

    context 'Errors::InvalidSession' do
      it 'should not report the exception, and redirect to the error page' do
        routes.draw { get 'invalid_session' => 'anonymous#invalid_session' }

        expect(Raven).not_to receive(:capture_exception)

        get :invalid_session
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context 'Other exceptions' do
      it 'should report the exception, and redirect to the error page' do
        routes.draw { get 'another_exception' => 'anonymous#another_exception' }

        expect(Raven).to receive(:capture_exception)

        get :another_exception
        expect(response).to redirect_to(unhandled_errors_path)
      end
    end
  end
end
