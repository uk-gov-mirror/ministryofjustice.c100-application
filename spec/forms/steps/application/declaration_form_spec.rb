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

  describe '#has_solicitor?' do
    before do
      allow(c100_application).to receive(:has_solicitor).and_return(has_solicitor)
    end

    context 'for a `nil` value' do
      let(:has_solicitor) { nil }
      it { expect(subject.has_solicitor?).to eq(false) }
    end

    context 'for a `no` value' do
      let(:has_solicitor) { 'no' }
      it { expect(subject.has_solicitor?).to eq(false) }
    end

    context 'for a `yes` value' do
      let(:has_solicitor) { 'yes' }
      it { expect(subject.has_solicitor?).to eq(true) }
    end
  end

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
