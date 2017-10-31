require 'spec_helper'

RSpec.describe Steps::Applicant::NumberOfChildrenForm do
  let(:arguments) { {
    c100_application: c100_application,
    number_of_children: number_of_children
  } }
  let(:c100_application) { instance_double(C100Application, number_of_children: nil) }
  let(:number_of_children) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    it { should validate_presence_of(:number_of_children) }

    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }
      let(:number_of_children) { '1' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'when number_of_children is valid' do
      let(:number_of_children) { '1' }

      it 'saves the record' do
        expect(c100_application).to receive(:update).with(
          number_of_children: 1
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end
  end
end
