require 'rails_helper'

RSpec.describe C100App::AlternativesDecisionTree do
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  let(:c100_application) do
    instance_double(
      C100Application,
      risk_of_abduction: risk_of_abduction,
      substance_abuse: substance_abuse,
      children_abuse: children_abuse,
      domestic_abuse: domestic_abuse,
      other_abuse: other_abuse,
    )
  end

  let(:risk_of_abduction) { nil }
  let(:substance_abuse) { nil }
  let(:children_abuse) { nil }
  let(:domestic_abuse) { nil }
  let(:other_abuse) { nil }

  it_behaves_like 'a decision tree'

  # Ok this the following scenarios are a bit annoying and verbose, but... MUTANT...
  context 'when the step is `court_acknowledgement`' do
    let(:step_params) {{court_acknowledgement: 'anything'}}

    context '`risk_of_abduction` concerns' do
      let(:risk_of_abduction) { value }

      context 'there are concerns' do
        let(:value) { 'yes' }
        it {is_expected.to have_destination(:start, :show)}
      end

      context 'there are not concerns' do
        let(:value) { 'no' }
        it {is_expected.to have_destination('/steps/children/names', :edit)}
      end

      context 'the question was not answered' do
        let(:value) { nil }
        it {is_expected.to have_destination('/steps/children/names', :edit)}
      end
    end

    context '`substance_abuse` concerns' do
      let(:substance_abuse) { value }

      context 'there are concerns' do
        let(:value) { 'yes' }
        it {is_expected.to have_destination(:start, :show)}
      end

      context 'there are not concerns' do
        let(:value) { 'no' }
        it {is_expected.to have_destination('/steps/children/names', :edit)}
      end

      context 'the question was not answered' do
        let(:value) { nil }
        it {is_expected.to have_destination('/steps/children/names', :edit)}
      end
    end

    context '`children_abuse` concerns' do
      let(:children_abuse) { value }

      context 'there are concerns' do
        let(:value) { 'yes' }
        it {is_expected.to have_destination(:start, :show)}
      end

      context 'there are not concerns' do
        let(:value) { 'no' }
        it {is_expected.to have_destination('/steps/children/names', :edit)}
      end

      context 'the question was not answered' do
        let(:value) { nil }
        it {is_expected.to have_destination('/steps/children/names', :edit)}
      end
    end

    context '`domestic_abuse` concerns' do
      let(:domestic_abuse) { value }

      context 'there are concerns' do
        let(:value) { 'yes' }
        it {is_expected.to have_destination(:start, :show)}
      end

      context 'there are not concerns' do
        let(:value) { 'no' }
        it {is_expected.to have_destination('/steps/children/names', :edit)}
      end

      context 'the question was not answered' do
        let(:value) { nil }
        it {is_expected.to have_destination('/steps/children/names', :edit)}
      end
    end

    context '`other_abuse` concerns' do
      let(:other_abuse) { value }

      context 'there are concerns' do
        let(:value) { 'yes' }
        it {is_expected.to have_destination(:start, :show)}
      end

      context 'there are not concerns' do
        let(:value) { 'no' }
        it {is_expected.to have_destination('/steps/children/names', :edit)}
      end

      context 'the question was not answered' do
        let(:value) { nil }
        it {is_expected.to have_destination('/steps/children/names', :edit)}
      end
    end
  end

  context 'when the step is `negotiation_tools`' do
    let(:step_params) { { negotiation_tools: 'anything' } }
    it { is_expected.to have_destination(:mediation, :edit) }
  end

  context 'when the step is `mediation`' do
    let(:step_params) { { mediation: 'anything' } }
    it { is_expected.to have_destination(:lawyer_negotiation, :edit) }
  end

  context 'when the step is `lawyer_negotiation`' do
    let(:step_params) { { lawyer_negotiation: 'anything' } }
    it { is_expected.to have_destination(:collaborative_law, :edit) }
  end

  context 'when the step is `collaborative_law`' do
    let(:step_params) { { collaborative_law: 'anything' } }
    it { is_expected.to have_destination('/steps/children/names', :edit) }
  end
end
