require 'rails_helper'

RSpec.describe C100App::ApplicationDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `without_notice`' do
    let(:c100_application) { instance_double(C100Application, without_notice: answer) }
    let(:step_params) { { without_notice: 'whatever' } }

    context 'and the answer is `yes`' do
      let(:answer) { 'yes' }
      it { is_expected.to have_destination(:without_notice_details, :edit) }
    end

    context 'and the answer is `no`' do
      let(:answer) { 'no' }
      it { is_expected.to have_destination('/steps/international/resident', :edit) }
    end
  end

  context 'when the step is `without_notice_details`' do
    let(:step_params) { { without_notice_details: 'anything' } }
    it { is_expected.to have_destination('/steps/international/resident', :edit) }
  end

  context 'when the step is `litigation_capacity`' do
    let(:c100_application) { instance_double(C100Application, reduced_litigation_capacity: answer) }
    let(:step_params) { { litigation_capacity: 'whatever' } }

    context 'and the answer is `yes`' do
      let(:answer) { 'yes' }
      it { is_expected.to have_destination(:litigation_capacity_details, :edit) }
    end

    context 'and the answer is `no`' do
      let(:answer) { 'no' }
      it { is_expected.to have_destination(:special_assistance, :edit) }
    end
  end

  context 'when the step is `litigation_capacity_details`' do
    let(:step_params) { { litigation_capacity_details: 'anything' } }
    it { is_expected.to have_destination(:special_assistance, :edit) }
  end

  context 'when the step is `special_assistance`' do
    let(:step_params) { { special_assistance: 'anything' } }
    it { is_expected.to have_destination(:special_arrangements, :edit) }
  end

  context 'when the step is `special_arrangements`' do
    let(:step_params) { { special_arrangements: 'anything' } }
    it { is_expected.to have_destination('/steps/international/resident', :edit) }
  end
end
