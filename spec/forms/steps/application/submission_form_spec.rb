require 'spec_helper'

RSpec.describe Steps::Application::SubmissionForm do
  let(:arguments) { {
    c100_application: c100_application,
    submission_type: submission_type,
    receipt_email: receipt_email,
  } }

  let(:c100_application) { instance_double(C100Application) }

  let(:submission_type) { SubmissionType::ONLINE.to_s }
  let(:receipt_email) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:submission_type, :inclusion) }
      it { should_not validate_presence_of(:receipt_email) }

      context 'receipt_email' do
        context 'email is not validated if not present' do
          let(:receipt_email) { nil }
          it { expect(subject).to be_valid }
        end

        context 'email is validated if present' do
          let(:receipt_email) { 'xxx' }
          it {
            expect(subject).not_to be_valid
            expect(subject.errors[:receipt_email]).to_not be_empty
          }
        end
      end
    end

    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'when form is valid' do
      context 'when submission type is `online`' do
        let(:submission_type) { SubmissionType::ONLINE.to_s }
        let(:receipt_email) { 'test@example.com' }

        it 'saves the record' do
          expect(c100_application).to receive(:update).with(
            submission_type: 'online',
            receipt_email: 'test@example.com',
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'when submission type is `print_and_post`' do
        let(:submission_type) { SubmissionType::PRINT_AND_POST.to_s }
        let(:receipt_email) { 'test@example.com' }

        it 'saves the record' do
          expect(c100_application).to receive(:update).with(
            submission_type: 'print_and_post',
            receipt_email: nil,
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
