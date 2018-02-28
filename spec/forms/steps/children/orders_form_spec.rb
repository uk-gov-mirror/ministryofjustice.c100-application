require 'spec_helper'

RSpec.describe Steps::Children::OrdersForm do
  let(:arguments) { {
    c100_application: c100_application,
    record: child,
    child_arrangements_home: '1',
    specific_issues_school: '0',
    specific_issues_medical: '1',
    prohibited_steps_moving_abduction: '0',
  } }

  let(:c100_application) { instance_double(C100Application) }
  let(:child) { instance_double(Child, child_order: child_order) }
  let(:child_order) { nil }

  subject { described_class.new(arguments) }

  describe 'custom getters override' do
    let(:child_order) { double('child_order', orders: ['child_arrangements_home']) }

    it 'returns true if the order is in the list' do
      expect(subject.child_arrangements_home).to eq(true)
    end

    it 'returns false if the order is not in the list' do
      expect(subject.specific_issues_school).to eq(false)
    end
  end

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'for valid details' do
      let(:expected_attributes) { { orders: [:child_arrangements_home, :specific_issues_medical] } }

      context 'when child_order does not exist' do
        let(:child_order) { nil }
        let(:new_child_order) { double }

        it 'creates the record if it does not exist' do
          expect(child).to receive(:build_child_order).and_return(new_child_order)

          expect(new_child_order).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'when record already exists' do
        let(:child_order) { instance_double(ChildOrder) }

        it 'updates the record if it already exists' do
          expect(child).to receive(:child_order).and_return(child_order)

          expect(child_order).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
