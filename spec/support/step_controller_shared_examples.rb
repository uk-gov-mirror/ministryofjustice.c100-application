require 'rails_helper'

RSpec.shared_examples 'a generic step controller' do |form_class, decision_tree_class|
  describe '#update' do
    let(:form_object) { instance_double(form_class, attributes: { foo: double }) }
    let(:form_class_params_name) { form_class.name.underscore }
    let(:expected_params) { { form_class_params_name => { foo: 'bar' } } }

    context 'when there is no case in the session' do
      before do
        # Needed because some specs that include these examples stub current_c100_application,
        # which is undesirable for this particular test
        allow(controller).to receive(:current_c100_application).and_return(nil)
      end

      it 'redirects to the invalid session error page' do
        put :update, params: expected_params
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    # context 'when there is an already submitted case in the session' do
    #   let(:existing_case) { C100Application.create(case_status: CaseStatus::SUBMITTED) }
    #
    #   before do
    #     # Needed because some specs that include these examples stub current_c100_application,
    #     # which is undesirable for this particular test
    #     allow(controller).to receive(:current_c100_application).and_call_original
    #   end
    #
    #   it 'redirects to the case already submitted error page' do
    #     put :update, params: expected_params, session: { c100_application_id: existing_case.id }
    #     expect(response).to redirect_to(case_submitted_errors_path)
    #   end
    # end

    context 'when a case in progress is in the session' do
      let(:existing_case) { C100Application.create }

      before do
        allow(form_class).to receive(:new).and_return(form_object)
      end

      context 'when the form saves successfully' do
        before do
          expect(form_object).to receive(:save).and_return(true)
        end

        let(:decision_tree) { instance_double(decision_tree_class, destination: '/expected_destination') }

        it 'asks the decision tree for the next destination and redirects there' do
          expect(decision_tree_class).to receive(:new).and_return(decision_tree)
          put :update, params: expected_params, session: { c100_application_id: existing_case.id }
          expect(subject).to redirect_to('/expected_destination')
        end
      end

      context 'when the form fails to save' do
        before do
          expect(form_object).to receive(:save).and_return(false)
        end

        it 'renders the question page again' do
          put :update, params: expected_params, session: { c100_application_id: existing_case.id }
          expect(subject).to render_template(:edit)
        end
      end
    end
  end
end

RSpec.shared_examples 'a starting point step controller' do
  describe '#edit' do
    context 'when no case exists in the session yet' do
      it 'creates a new case' do
        expect { get :edit }.to change { C100Application.count }.by(1)
      end

      it 'responds with HTTP success' do
        get :edit
        expect(response).to be_successful
      end

      it 'sets the case ID in the session' do
        get :edit
        expect(session[:c100_application_id]).to eq(C100Application.first.id)
      end
    end

    context 'when a case exists in the session' do
      let!(:existing_case) { C100Application.create(navigation_stack: ['/not', '/empty']) }

      it 'does not create a new case' do
        expect {
          get :edit, session: { c100_application_id: existing_case.id }
        }.to_not change { C100Application.count }
      end

      it 'responds with HTTP success' do
        get :edit, session: { c100_application_id: existing_case.id }
        expect(response).to be_successful
      end

      it 'does not change the case ID in the session' do
        get :edit, session: { c100_application_id: existing_case.id }
        expect(session[:c100_application_id]).to eq(existing_case.id)
      end

      it 'clears the navigation stack in the session' do
        get :edit, session: { c100_application_id: existing_case.id }
        existing_case.reload

        expect(existing_case.navigation_stack).to eq([controller.request.fullpath])
      end
    end
  end
end

RSpec.shared_examples 'a savepoint step controller' do
  describe '#edit' do
    let!(:existing_c100) { C100Application.create(navigation_stack: ['/not', '/empty']) }

    before do
      allow(controller).to receive(:current_c100_application).and_return(existing_c100)
    end

    it 'initialises the navigation stack in the session introducing the entrypoint' do
      get :edit
      expect(existing_c100.reload.navigation_stack).to eq(['/entrypoint/v1', controller.request.fullpath])
    end

    it 'does not change the status on edit' do
      expect {
        get :edit
      }.to_not change { existing_c100.status }
    end

    context 'saving the application for later on `edit`' do
      context 'for a signed in user' do
        let(:user) { instance_double(User) }

        before do
          sign_in(user)
        end

        it 'does not save the case for later' do
          expect(C100App::SaveApplicationForLater).not_to receive(:new)
          get :edit
        end
      end
    end
  end

  describe '#update' do
    let!(:existing_c100) { C100Application.create(navigation_stack: ['/not', '/empty']) }

    before do
      allow(controller).to receive(:current_c100_application).and_return(existing_c100)
    end

    it 'changes the status to `in_progress`' do
      expect {
        put :update, params: {}
      }.to change { existing_c100.status }.from('screening').to('in_progress')
    end

    context 'saving the case for later on `update`' do
      context 'for a signed in user' do
        let(:user) { instance_double(User) }

        before do
          sign_in(user)
        end

        it 'saves the case for later' do
          expect(C100App::SaveApplicationForLater).to receive(:new).with(
            an_instance_of(C100Application),
            user
          ).and_return(double.as_null_object)

          put :update, params: {}
        end
      end

      context 'for a signed out user' do
        it 'does not save the case for later' do
          expect(C100App::SaveApplicationForLater).not_to receive(:new)
          put :update, params: {}
        end
      end
    end
  end
end

RSpec.shared_examples 'an intermediate step controller' do |form_class, decision_tree_class|
  include_examples 'a generic step controller', form_class, decision_tree_class

  describe '#edit' do
    context 'when no case exists in the session yet' do
      before do
        # Needed because some specs that include these examples stub current_c100_application,
        # which is undesirable for this particular test
        allow(controller).to receive(:current_c100_application).and_return(nil)
      end

      it 'redirects to the invalid session error page' do
        get :edit
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context 'when a case exists in the session' do
      let!(:existing_case) { C100Application.create }

      it 'responds with HTTP success' do
        get :edit, session: { c100_application_id: existing_case.id }
        expect(response).to be_successful
      end
    end
  end
end

RSpec.shared_examples 'an intermediate step controller without update' do
  context '#update' do
    it 'raises an exception' do
      expect { put :update }.to raise_error(AbstractController::ActionNotFound)
    end
  end

  describe '#edit' do
    context 'when no case exists in the session yet' do
      it 'raises an exception' do
        expect { get :edit }.to raise_error(RuntimeError)
      end
    end

    context 'when a case exists in the session' do
      let!(:existing_case) { C100Application.create }

      it 'responds with HTTP success' do
        get :edit, session: { c100_application_id: existing_case.id }
        expect(response).to be_successful
      end
    end
  end
end

RSpec.shared_examples 'an names CRUD step controller' do |form_class, decision_tree_class, resource_class|
  include_examples 'an intermediate step controller', form_class, decision_tree_class

  describe '#destroy' do
    context 'when no case exists in the session yet' do
      before do
        # Needed because some specs that include these examples stub current_c100_application,
        # which is undesirable for this particular test
        allow(controller).to receive(:current_c100_application).and_return(nil)
      end

      it 'redirects to the invalid session error page' do
        delete :destroy, params: {id: '123'}
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context 'when a case exists in the session' do
      let!(:existing_case) {C100Application.create}
      let!(:existing_resource) { resource_class.create(c100_application: existing_case) }

      before do
        allow(controller).to receive(:current_c100_application).and_return(existing_case)
      end

      it 'redirects to edit an empty resource' do
        delete :destroy, params: {id: existing_resource.id}
        expect(response).to redirect_to(action: :edit, id: nil)
      end
    end
  end
end

RSpec.shared_examples 'a show step controller' do
  describe '#show' do
    context 'when no case exists in the session' do
      before do
        # Needed because some specs that include these examples stub current_c100_application,
        # which is undesirable for this particular test
        allow(controller).to receive(:current_c100_application).and_return(nil)
      end

      it 'redirects to the invalid session error page' do
        get :show
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context 'when a case exists in the session' do
      let!(:existing_case) { C100Application.create }

      it 'responds with HTTP success' do
        get :show, session: { c100_application_id: existing_case.id }
        expect(response).to be_successful
      end
    end
  end
end

RSpec.shared_examples 'a summary step controller' do
  describe '#show' do
    context 'when no case exists in the session' do
      before do
        # Needed because some specs that include these examples stub current_c100_application,
        # which is undesirable for this particular test
        allow(controller).to receive(:current_c100_application).and_return(nil)
      end

      it 'redirects to the invalid session error page' do
        get :show
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context 'when a case exists in the session' do
      let!(:existing_case) { C100Application.create }

      context 'HTML format' do
        it 'assigns the presenter' do
          get :show, format: :html, session: { c100_application_id: existing_case.id }

          expect(subject).to render_template(:show)
          expect(assigns[:presenter]).to be_an_instance_of(Summary::HtmlPresenter)
        end
      end

      context 'PDF format' do
        let(:pdf_presenter) { instance_double(Summary::PdfPresenter, generate: nil, to_pdf: 'a majestic pdf') }

        before do
          allow(Summary::PdfPresenter).to receive(:new).and_return(pdf_presenter)
        end

        it 'generates and renders the PDF' do
          get :show, format: :pdf, session: { c100_application_id: existing_case.id }

          expect(response.body).to eq('a majestic pdf')
        end
      end
    end
  end
end
