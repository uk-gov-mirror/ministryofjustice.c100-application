require 'spec_helper'

RSpec.describe Steps::Petition::OtherIssueForm do
  let(:arguments) { {
    c100_application: c100_application,
    other_details: 'details',
    child_arrangements_order: '1',
    prohibited_steps_order: '0',
    specific_issue_order: '1'
  } }

  let(:c100_application) { instance_double(C100Application, asking_order: asking_order) }
  let(:asking_order) { double('asking_order') }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'validations' do
      it { should validate_presence_of(:other_details) }
    end

    context 'for valid details' do
      let(:expected_attributes) {
        {
          other_details: 'details',
          child_arrangements_order: true,
          prohibited_steps_order: false,
          specific_issue_order: true
        }
      }

      context 'when record does not exist' do
        before do
          allow(c100_application).to receive(:asking_order).and_return(nil)
        end

        it 'creates the record if it does not exist' do
          expect(c100_application).to receive(:build_asking_order).and_return(asking_order)

          expect(asking_order).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'when record already exists' do
        before do
          allow(c100_application).to receive(:asking_order).and_return(asking_order)
        end

        it 'updates the record if it already exists' do
          expect(c100_application).not_to receive(:build_asking_order)

          expect(asking_order).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
