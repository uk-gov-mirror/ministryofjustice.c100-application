require 'rails_helper'

RSpec.describe PetitionOrder do
  let(:value) { :foo }
  subject     { described_class.new(value) }

  describe '.values' do
    it 'returns all possible values' do
      expect(described_class.values.map(&:to_s)).to eq(%w(
        child_home
        child_times
        child_contact
        child_return
        child_abduction
        child_flight
        child_specific_issue_school
        child_specific_issue_religion
        child_specific_issue_name
        child_specific_issue_medical
        child_specific_issue_abroad
        other
      ))
    end
  end

  describe 'CHILD_ARRANGEMENTS' do
    it 'returns the expected values' do
      expect(described_class::CHILD_ARRANGEMENTS.map(&:to_s)).to eq(%w(
        child_home
        child_times
        child_contact
        child_return
      ))
    end
  end

  describe 'SPECIFIC_ISSUES' do
    it 'returns the expected values' do
      expect(described_class::SPECIFIC_ISSUES.map(&:to_s)).to eq(%w(
        child_specific_issue_school
        child_specific_issue_religion
        child_specific_issue_name
        child_specific_issue_medical
        child_specific_issue_abroad
      ))
    end
  end

  describe 'PROHIBITED_STEPS' do
    it 'returns the expected values' do
      expect(described_class::PROHIBITED_STEPS.map(&:to_s)).to eq(%w(
        child_abduction
        child_flight
      ))
    end
  end

  describe 'OTHER' do
    it 'returns the expected values' do
      expect(described_class::OTHER.map(&:to_s)).to eq(%w(
        other
      ))
    end
  end
end
