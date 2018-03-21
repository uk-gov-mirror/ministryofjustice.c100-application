require 'rails_helper'

RSpec.describe PetitionOrder do
  let(:value) { :foo }
  subject     { described_class.new(value) }

  describe '.values' do
    it 'returns all possible values' do
      expect(described_class.values.map(&:to_s)).to eq(%w(
        child_arrangements_home
        child_arrangements_time
        child_arrangements_contact
        child_arrangements_access
        group_prohibited_steps
        prohibited_steps_names
        prohibited_steps_medical
        prohibited_steps_holiday
        prohibited_steps_moving
        prohibited_steps_moving_abroad
        group_specific_issues
        specific_issues_holiday
        specific_issues_school
        specific_issues_religion
        specific_issues_names
        specific_issues_medical
        specific_issues_moving
        specific_issues_moving_abroad
        specific_issues_child_return
        other_issue
      ))
    end
  end

  describe 'CHILD_ARRANGEMENTS' do
    it 'returns the expected values' do
      expect(described_class::CHILD_ARRANGEMENTS.map(&:to_s)).to eq(%w(
        child_arrangements_home
        child_arrangements_time
        child_arrangements_contact
        child_arrangements_access
      ))
    end
  end

  describe 'PROHIBITED_STEPS' do
    it 'returns the expected values' do
      expect(described_class::PROHIBITED_STEPS.map(&:to_s)).to eq(%w(
        prohibited_steps_names
        prohibited_steps_medical
        prohibited_steps_holiday
        prohibited_steps_moving
        prohibited_steps_moving_abroad
      ))
    end
  end

  describe 'SPECIFIC_ISSUES' do
    it 'returns the expected values' do
      expect(described_class::SPECIFIC_ISSUES.map(&:to_s)).to eq(%w(
        specific_issues_holiday
        specific_issues_school
        specific_issues_religion
        specific_issues_names
        specific_issues_medical
        specific_issues_moving
        specific_issues_moving_abroad
        specific_issues_child_return
      ))
    end
  end

  describe 'OTHER_ISSUE' do
    it 'returns the expected values' do
      expect(described_class::OTHER_ISSUE.to_s).to eq('other_issue')
    end
  end
end
