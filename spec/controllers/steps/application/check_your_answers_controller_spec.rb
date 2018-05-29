require 'rails_helper'

RSpec.describe Steps::Application::CheckYourAnswersController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Application::DeclarationForm, C100App::ApplicationDecisionTree

  describe '#edit' do
    context 'when a case exists in the session' do
      let!(:existing_case) { C100Application.create(status: :in_progress) }

      it 'assigns the HTML presenter' do
        get :edit, session: { c100_application_id: existing_case.id }

        expect(response).to be_successful
        expect(assigns[:presenter]).to be_an_instance_of(Summary::HtmlPresenter)
      end
    end
  end

  describe '#resume' do
    context 'when a case exists in the session' do
      let!(:existing_case) { C100Application.create(status: :in_progress) }

      it 'assigns the HTML presenter' do
        get :resume, session: { c100_application_id: existing_case.id }

        expect(response).to render_template(:resume)
        expect(assigns[:presenter]).to be_an_instance_of(Summary::HtmlPresenter)
      end
    end
  end

  context 'step name based on submission type' do
    let(:existing_case) { C100Application.create(status: :in_progress, submission_type: submission_type) }

    context 'when the submission type is online' do
      let(:submission_type) { SubmissionType::ONLINE }

      it 'asks the decision tree for the next destination and redirects there' do
        expect(subject).to receive(:update_and_advance).with(Steps::Application::DeclarationForm, as: :online_submission)
        put :update, params: {}, session: { c100_application_id: existing_case.id }
      end
    end

    context 'when the submission type is print and post' do
      let(:submission_type) { SubmissionType::PRINT_AND_POST }

      it 'asks the decision tree for the next destination and redirects there' do
        expect(subject).to receive(:update_and_advance).with(Steps::Application::DeclarationForm, as: :print_and_post_submission)
        put :update, params: {}, session: { c100_application_id: existing_case.id }
      end
    end

    context 'when the submission type is not present' do
      let(:submission_type) { nil }

      it 'asks the decision tree for the next destination and redirects there' do
        expect(subject).to receive(:update_and_advance).with(Steps::Application::DeclarationForm, as: :print_and_post_submission)
        put :update, params: {}, session: { c100_application_id: existing_case.id }
      end
    end
  end
end
