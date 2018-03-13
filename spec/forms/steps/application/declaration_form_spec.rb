require 'spec_helper'

RSpec.describe Steps::Application::DeclarationForm do
  let(:arguments) { {
    c100_application: c100_application,
    declaration_made: declaration_made,
  } }
  let(:c100_application) { instance_double(C100Application, declaration_made: nil) }
  let(:declaration_made) { '1' }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'validations' do
      it { should validate_presence_of(:declaration_made) }
    end

    context 'when form is valid' do
      it 'saves the record' do
        expect(c100_application).to receive(:update).with(
          declaration_made: true
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
