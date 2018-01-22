require 'rails_helper'

RSpec.describe UrgencyExemptions do
  let(:value) { :foo }
  subject     { described_class.new(value) }

  describe 'Risk exemptions' do
    context 'GROUP_RISK' do
      it 'returns the expected values' do
        expect(described_class::GROUP_RISK.to_s).to eq('group_risk')
      end
    end

    context 'RISK' do
      it 'returns the expected values' do
        expect(described_class::RISK.map(&:to_s)).to eq(%w(
          risk_applicant
          risk_unreasonable_hardship
          risk_children
          risk_unlawful_removal_retention
        ))
      end
    end
  end

  describe 'Miscarriage exemptions' do
    context 'GROUP_MISCARRIAGE' do
      it 'returns the expected values' do
        expect(described_class::GROUP_MISCARRIAGE.to_s).to eq('group_miscarriage')
      end
    end

    context 'MISCARRIAGE' do
      it 'returns the expected values' do
        expect(described_class::MISCARRIAGE.map(&:to_s)).to eq(%w(
          miscarriage_justice
          miscarriage_irretrievable_problems
        ))
      end
    end
  end

  context 'URGENCY_NONE' do
    it 'returns the expected values' do
      expect(described_class::URGENCY_NONE.to_s).to eq('urgency_none')
    end
  end
end
