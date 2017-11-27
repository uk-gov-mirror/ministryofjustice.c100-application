require 'spec_helper'

RSpec.describe Steps::Petition::OrdersForm do
  let(:arguments) { {
    c100_application: c100_application,
    child_home: '1',
    child_times: '1',
    child_contact: '1',
    child_specific_issue: '0',
    child_specific_issue_school: '0',
    child_specific_issue_religion: '0',
    child_specific_issue_name: '0',
    child_specific_issue_medical: '0',
    child_specific_issue_abroad: '0',
    consent_order: '0',
    child_return: '0',
    child_abduction: '0',
    child_flight: '0',
    other: '0',
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

    context 'for valid details' do
      let(:expected_attributes) {
        {
          child_home: true,
          child_times: true,
          child_contact: true,
          child_specific_issue: false,
          child_specific_issue_school: false,
          child_specific_issue_religion: false,
          child_specific_issue_name: false,
          child_specific_issue_medical: false,
          child_specific_issue_abroad: false,
          consent_order: false,
          child_return: false,
          child_abduction: false,
          child_flight: false,
          other: false,
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
