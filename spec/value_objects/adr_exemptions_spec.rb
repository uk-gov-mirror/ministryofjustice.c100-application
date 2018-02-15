require 'rails_helper'

RSpec.describe AdrExemptions do
  let(:value) { :foo }
  subject     { described_class.new(value) }

  describe 'Previous ADR exemptions' do
    context 'GROUP_PREVIOUS_ADR' do
      it 'returns the expected values' do
        expect(described_class::GROUP_PREVIOUS_ADR.to_s).to eq('group_previous_adr')
      end
    end

    context 'PREVIOUS_ADR' do
      it 'returns the expected values' do
        expect(described_class::PREVIOUS_ADR.map(&:to_s)).to eq(%w(
          previous_attendance
          ongoing_attendance
          existing_proceedings_attendance
        ))
      end
    end
  end

  describe 'Previous MIAM exemptions' do
    context 'GROUP_PREVIOUS_MIAM' do
      it 'returns the expected values' do
        expect(described_class::GROUP_PREVIOUS_MIAM.to_s).to eq('group_previous_miam')
      end
    end

    context 'PREVIOUS_MIAM' do
      it 'returns the expected values' do
        expect(described_class::PREVIOUS_MIAM.map(&:to_s)).to eq(%w(
          previous_exemption
          existing_proceedings_exemption
        ))
      end
    end
  end

  context 'ADR_NONE' do
    it 'returns the expected values' do
      expect(described_class::ADR_NONE.to_s).to eq('adr_none')
    end
  end
end
