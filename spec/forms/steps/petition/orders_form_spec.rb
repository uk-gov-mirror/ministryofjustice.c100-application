require 'spec_helper'

RSpec.describe Steps::Petition::OrdersForm do
  let(:arguments) { {
    c100_application: c100_application,
    child_arrangements_home: '1',
    group_prohibited_steps: '1',
    prohibited_steps_holiday: '1',
    group_specific_issues: '1',
    specific_issues_school: '0',
    specific_issues_medical: '1',
    other_issue: other_issue,
    orders_additional_details: orders_additional_details,
  } }

  let(:c100_application) {
    instance_double(C100Application, orders: orders, orders_additional_details: orders_additional_details)
  }

  let(:orders) { [] }
  let(:other_issue) { nil }
  let(:orders_additional_details) { nil }

  subject { described_class.new(arguments) }

  describe 'custom build, loading of attributes' do
    subject { described_class.build(c100_application) } # NOTE: Using custom build

    let(:orders) { %w(child_arrangements_home specific_issues_medical) }

    it 'returns true if the order is in the list' do
      expect(subject.child_arrangements_home).to eq(true)
    end

    it 'returns false if the order is not in the list' do
      expect(subject.specific_issues_school).to eq(false)
    end

    context 'other attributes explicitly set' do
      let(:orders_additional_details) { 'additional details' }

      it { expect(subject.orders_additional_details).to eq('additional details') }
      it { expect(subject.c100_application).to eq(c100_application) }
    end
  end

  context 'validations' do
    context 'no orders selected' do
      let(:arguments) { { c100_application: c100_application } }

      it 'has a top level validation error' do
        expect(subject).to_not be_valid
        expect(subject.errors.added?(:base, :blank_orders)).to eq(true)
      end
    end

    context 'only a group checkbox was selected' do
      context 'group_prohibited_steps' do
        let(:arguments) { {
          c100_application: c100_application,
          group_prohibited_steps: '1',
          group_specific_issues: '1',
          specific_issues_school: '1',
        } }

        it 'has a validation error in the group' do
          expect(subject).to_not be_valid

          expect(subject.errors.added?(:group_prohibited_steps, :blank_orders)).to eq(true)
          expect(subject.errors.added?(:group_specific_issues, :blank_orders)).to eq(false)
          expect(subject.errors.added?(:base, :blank_orders)).to eq(false)
        end
      end

      context 'group_specific_issues' do
        let(:arguments) { {
          c100_application: c100_application,
          group_specific_issues: '1',
          group_prohibited_steps: '1',
          prohibited_steps_medical: '1',
        } }

        it 'has a validation error in the group' do
          expect(subject).to_not be_valid

          expect(subject.errors.added?(:group_specific_issues, :blank_orders)).to eq(true)
          expect(subject.errors.added?(:group_prohibited_steps, :blank_orders)).to eq(false)
          expect(subject.errors.added?(:base, :blank_orders)).to eq(false)
        end
      end

      context 'do not produce multiple errors' do
        let(:arguments) { { c100_application: c100_application, group_specific_issues: '1' } }

        it 'has only the group error' do
          expect(subject).to_not be_valid

          expect(subject.errors.size).to eq(1)
          expect(subject.errors.added?(:group_specific_issues, :blank_orders)).to eq(true)
        end
      end
    end

    context '`other_issue` is checked' do
      let(:other_issue) { '1' }
      it { should validate_presence_of(:orders_additional_details, :blank) }
    end

    context '`other_issue` is not checked' do
      let(:other_issue) { '0' }
      it { should_not validate_presence_of(:orders_additional_details, :blank) }
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
      it 'updates the record' do
        expect(c100_application).to receive(:update).with(
          orders: [
            :child_arrangements_home,
            :group_prohibited_steps,
            :prohibited_steps_holiday,
            :group_specific_issues,
            :specific_issues_medical
          ],
          orders_additional_details: nil,
        ).and_return(true)

        expect(subject.save).to be(true)
      end

      context 'for other issue details' do
        let(:orders_additional_details) { 'details' }

        let(:arguments) { {
          c100_application: c100_application,
          other_issue: '1',
          orders_additional_details: orders_additional_details,
        } }

        it 'updates the record' do
          expect(c100_application).to receive(:update).with(
            orders: [:other_issue],
            orders_additional_details: 'details',
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'when other issue details are already set' do
        let(:existing_details){ 'existing details' }
        let(:c100_application) {
          instance_double(C100Application,
            orders: existing_orders,
            orders_additional_details: existing_details
          )
        }

        context 'and the other issue checkbox is un-checked' do
          let(:existing_orders){ [:other_issue, :group_specific_issues, :specific_issues_medical] }
          let(:existing_details){ 'existing details' }
          let(:arguments) { {
            c100_application: c100_application,
            group_specific_issues: '1',
            specific_issues_medical: '1',
            orders_additional_details: existing_details,
          } }

          it 'updates the record with orders_additional_details set to nil' do
            expect(c100_application).to receive(:update).with(
              orders: [:group_specific_issues, :specific_issues_medical],
              orders_additional_details: nil,
            ).and_return(true)
            subject.save
          end
        end
      end
    end
  end
end
