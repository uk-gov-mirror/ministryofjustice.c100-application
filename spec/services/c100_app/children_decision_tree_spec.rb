require 'rails_helper'

RSpec.describe C100App::ChildrenDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }
  let(:record)           { nil }

  let(:c100_application) {instance_double(C100Application)}

  subject {
    described_class.new(
      c100_application: c100_application,
      record: record,
      step_params: step_params,
      as: as,
      next_step: next_step
    )
  }

  it_behaves_like 'a decision tree'

  context 'when the step is `add_another_name`' do
    let(:step_params) {{'add_another_name' => 'anything'}}
    it {is_expected.to have_destination(:names, :edit)}
  end

  context 'when the step is `names_finished`' do
    let(:step_params) {{'names_finished' => 'anything'}}
    let(:c100_application) {instance_double(C100Application, child_ids: [1, 2, 3])}

    it 'goes to edit the details of the first child' do
      expect(subject.destination).to eq(controller: :personal_details, action: :edit, id: 1)
    end
  end

  context 'when the step is `personal_details`' do
    let(:step_params) {{'personal_details' => 'anything'}}
    let(:c100_application) {instance_double(C100Application, child_ids: [1, 2, 3])}

    context 'when there are remaining children' do
      let(:record) { double('Child', id: 1) }

      it 'goes to edit the details of the next child' do
        expect(subject.destination).to eq(controller: :personal_details, action: :edit, id: 2)
      end
    end

    context 'when all children have been edited' do
      let(:record) { double('Child', id: 3) }
      it {is_expected.to have_destination(:additional_details, :edit)}
    end
  end

  context 'when the step is `additional_details`' do
    let(:step_params) {{'additional_details' => 'anything'}}
    it {is_expected.to have_destination(:other_children, :edit)}
  end

  context 'when the step is `other_children`' do
    let(:c100_application) { instance_double(C100Application, other_children: value) }
    let(:step_params) { { other_children: 'anything' } }

    context 'and the answer is `yes`' do
      let(:value) { 'yes' }
      it { is_expected.to have_destination('/steps/other_children/names', :edit) }
    end

    context 'and the answer is `no`' do
      let(:value) { 'no' }
      it { is_expected.to have_destination('/steps/applicant/personal_details', :edit) }
    end
  end
end
