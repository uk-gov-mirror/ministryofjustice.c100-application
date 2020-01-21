require 'spec_helper'

RSpec.describe Steps::Application::DeclarationForm do
  let(:arguments) { {
    c100_application: c100_application,
    declaration_signee: declaration_signee,
    declaration_signee_capacity: declaration_signee_capacity,
  } }

  let(:c100_application) { instance_double(C100Application) }
  let(:declaration_signee) { 'Full Name' }
  let(:declaration_signee_capacity) { 'applicant' }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'validations' do
      it { should validate_presence_of(:declaration_signee) }
      it { should validate_presence_of(:declaration_signee_capacity, :inclusion) }
    end

    context 'when form is valid' do
      it 'saves the record' do
        expect(c100_application).to receive(:update).with(
          declaration_signee: 'Full Name',
          declaration_signee_capacity: 'applicant',
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
