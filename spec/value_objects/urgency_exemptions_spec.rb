require 'rails_helper'

RSpec.describe UrgencyExemptions do
  let(:value) { :foo }
  subject     { described_class.new(value) }

  context 'RISK_APPLICANT' do
    it 'returns the expected values' do
      expect(described_class::RISK_APPLICANT.to_s).to eq('risk_applicant')
    end
  end

  context 'UNREASONABLE_HARDSHIP' do
    it 'returns the expected values' do
      expect(described_class::UNREASONABLE_HARDSHIP.to_s).to eq('unreasonable_hardship')
    end
  end

  describe 'Risk exemptions' do
    context 'GROUP_RISK' do
      it 'returns the expected values' do
        expect(described_class::GROUP_RISK.to_s).to eq('group_risk')
      end
    end

    context 'RISK' do
      it 'returns the expected values' do
        expect(described_class::RISK.map(&:to_s)).to eq(%w(
          risk_children
          risk_unlawful_removal_retention
        ))
      end
    end
  end

  context 'MISCARRIAGE_JUSTICE' do
    it 'returns the expected values' do
      expect(described_class::MISCARRIAGE_JUSTICE.to_s).to eq('miscarriage_justice')
    end
  end

  context 'IRRETRIEVABLE_PROBLEMS' do
    it 'returns the expected values' do
      expect(described_class::IRRETRIEVABLE_PROBLEMS.to_s).to eq('irretrievable_problems')
    end
  end

  context 'INTERNATIONAL_PROCEEDINGS' do
    it 'returns the expected values' do
      expect(described_class::INTERNATIONAL_PROCEEDINGS.to_s).to eq('international_proceedings')
    end
  end

  context 'URGENCY_NONE' do
    it 'returns the expected values' do
      expect(described_class::URGENCY_NONE.to_s).to eq('urgency_none')
    end
  end
end
