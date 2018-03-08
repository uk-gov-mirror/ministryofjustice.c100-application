require 'rails_helper'

RSpec.describe C100App::MiamExemptionsDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `domestic`' do
    let(:step_params) { { domestic: 'anything' } }
    it { is_expected.to have_destination(:protection, :edit) }
  end

  context 'when the step is `protection`' do
    let(:step_params) { { protection: 'anything' } }
    it { is_expected.to have_destination(:urgency, :edit) }
  end

  context 'when the step is `urgency`' do
    let(:step_params) { { urgency: 'anything' } }
    it { is_expected.to have_destination(:adr, :edit) }
  end

  context 'when the step is `adr`' do
    let(:step_params) { { adr: 'anything' } }
    it { is_expected.to have_destination(:misc, :edit) }
  end

  context 'when the step is `misc`' do
    let(:step_params) { { misc: 'anything' } }
    it { is_expected.to have_destination('/steps/safety_questions/start', :show) }
  end

  describe '#playback_destination' do
    let(:c100_application) { C100Application.new(attributes) }
    let(:attributes) {
      {
        child_protection_cases: 'no',
        miam_certification_number: nil,
        substance_abuse: 'no',
        miam_exemption: nil,
      }
    }

    context 'when children have been involved in court cases' do
      let(:attributes) { super().merge(child_protection_cases: 'yes') }

      it {
        expect(
          subject.playback_destination
        ).to eq(controller: '/steps/petition/orders', action: :edit)
      }
    end

    context 'when MIAM certification is present' do
      let(:attributes) { super().merge(miam_certification_number: '1234X') }

      it {
        expect(
          subject.playback_destination
        ).to eq(controller: '/steps/petition/orders', action: :edit)
      }
    end

    context 'when there are MIAM exemptions' do
      let(:attributes) { super().merge(miam_exemption: MiamExemption.new(domestic: ['anything'])) }

      it {
        expect(
          subject.playback_destination
        ).to eq(controller: '/steps/miam_exemptions/reasons_playback', action: :show)
      }
    end

    context 'when there are safety concerns' do
      let(:attributes) { super().merge(substance_abuse: 'yes') }

      it {
        expect(
          subject.playback_destination
        ).to eq(controller: '/steps/miam_exemptions/safety_playback', action: :show)
      }
    end

    context 'when there are no exemptions or safety concerns' do
      let(:c100_application) { C100Application.new }

      it {
        expect(
          subject.playback_destination
        ).to eq(controller: '/steps/miam_exemptions/exit_page', action: :show)
      }
    end
  end
end
