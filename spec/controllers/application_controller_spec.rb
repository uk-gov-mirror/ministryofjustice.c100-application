require 'rails_helper'

RSpec.describe ApplicationController do
  controller do
    def invalid_session; raise Errors::InvalidSession; end
    def application_not_found; raise Errors::ApplicationNotFound; end
    def application_completed; raise Errors::ApplicationCompleted; end
    def application_screening; raise Errors::ApplicationScreening; end
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

    context 'Errors::ApplicationNotFound' do
      it 'should not report the exception, and redirect to the error page' do
        routes.draw { get 'application_not_found' => 'anonymous#application_not_found' }

        expect(Raven).not_to receive(:capture_exception)

        get :application_not_found
        expect(response).to redirect_to(application_not_found_errors_path)
      end
    end

    context 'Errors::ApplicationScreening' do
      it 'should not report the exception, and redirect to the error page' do
        routes.draw { get 'application_screening' => 'anonymous#application_screening' }

        expect(Raven).not_to receive(:capture_exception)

        get :application_screening
        expect(response).to redirect_to(application_screening_errors_path)
      end
    end

    context 'Errors::ApplicationCompleted' do
      it 'should not report the exception, and redirect to the error page' do
        routes.draw { get 'application_completed' => 'anonymous#application_completed' }

        expect(Raven).not_to receive(:capture_exception)

        get :application_completed
        expect(response).to redirect_to(application_completed_errors_path)
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
