require 'spec_helper'

RSpec.describe Steps::AttendingCourt::LanguageForm do
  let(:arguments) { {
    c100_application: c100_application,
    language_interpreter: language_interpreter,
    language_interpreter_details: language_interpreter_details,
    sign_language_interpreter: sign_language_interpreter,
    sign_language_interpreter_details: sign_language_interpreter_details,
  } }

  let(:c100_application) { instance_double(C100Application) }

  let(:language_interpreter) { true }
  let(:language_interpreter_details) { 'details' }
  let(:sign_language_interpreter) { true }
  let(:sign_language_interpreter_details) { 'details' }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      context 'when `language_interpreter` is checked' do
        let(:language_interpreter) { true }
        it { should validate_presence_of(:language_interpreter_details) }
      end

      context 'when `language_interpreter` is not checked' do
        let(:language_interpreter) { false }
        it { should_not validate_presence_of(:language_interpreter_details) }
      end

      context 'when `sign_language_interpreter` is checked' do
        let(:sign_language_interpreter) { true }
        it { should validate_presence_of(:sign_language_interpreter_details) }
      end

      context 'when `sign_language_interpreter` is not checked' do
        let(:sign_language_interpreter) { false }
        it { should_not validate_presence_of(:sign_language_interpreter_details) }
      end
    end

    context 'ensure leftovers are deleted when deselecting a checkbox' do
      context '`language_interpreter` is true and `language_interpreter_details` is filled' do
        let(:language_interpreter) { true }
        let(:language_interpreter_details) { 'blah blah' }

        it_behaves_like 'a has-one-association form',
                        association_name: :court_arrangement,
                        expected_attributes: {
                          language_interpreter: true,
                          language_interpreter_details: 'blah blah',
                          sign_language_interpreter: true,
                          sign_language_interpreter_details: 'details'
                        }
      end

      context '`language_interpreter` is false and `language_interpreter_details` is filled' do
        let(:language_interpreter) { false }
        let(:language_interpreter_details) { 'blah blah' }

        it_behaves_like 'a has-one-association form',
                        association_name: :court_arrangement,
                        expected_attributes: {
                          language_interpreter: false,
                          language_interpreter_details: nil,
                          sign_language_interpreter: true,
                          sign_language_interpreter_details: 'details'
                        }
      end

      context '`sign_language_interpreter` is true and `sign_language_interpreter_details` is filled' do
        let(:sign_language_interpreter) { true }
        let(:sign_language_interpreter_details) { 'blah blah' }

        it_behaves_like 'a has-one-association form',
                        association_name: :court_arrangement,
                        expected_attributes: {
                          language_interpreter: true,
                          language_interpreter_details: 'details',
                          sign_language_interpreter: true,
                          sign_language_interpreter_details: 'blah blah'
                        }
      end

      context '`sign_language_interpreter` is false and `sign_language_interpreter_details` is filled' do
        let(:sign_language_interpreter) { false }
        let(:sign_language_interpreter_details) { 'blah blah' }

        it_behaves_like 'a has-one-association form',
                        association_name: :court_arrangement,
                        expected_attributes: {
                            language_interpreter: true,
                            language_interpreter_details: 'details',
                            sign_language_interpreter: false,
                            sign_language_interpreter_details: nil
                        }
      end
    end
  end
end
