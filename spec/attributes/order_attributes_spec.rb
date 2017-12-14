require 'rails_helper'

RSpec.describe OrderAttributes do
  #
  # These are silly tests, just sanity check to ensure the constants are updated (for example
  # adding or removing orders, or reordering) consciously, and not due to fat finger. If the
  # constants ever change, at least these scenarios need to also be updated consciously.
  #
  describe 'CHILD_ARRANGEMENTS' do
    it 'returns the expected array' do
      expect(described_class::CHILD_ARRANGEMENTS).to match_array(
        [
          :child_home,
          :child_times,
          :child_contact
        ]
      )
    end
  end

  describe 'SPECIFIC_ISSUES' do
    it 'returns the expected array' do
      expect(described_class::SPECIFIC_ISSUES).to match_array(
        [
          :child_specific_issue_school,
          :child_specific_issue_religion,
          :child_specific_issue_name,
          :child_specific_issue_medical,
          :child_specific_issue_abroad,
          :child_return
        ]
      )
    end
  end

  describe 'PROHIBITED_STEPS' do
    it 'returns the expected array' do
      expect(described_class::PROHIBITED_STEPS).to match_array(
        [
          :child_abduction,
          :child_flight
        ]
      )
    end
  end

  describe 'OTHER' do
    it 'returns the expected array' do
      expect(described_class::OTHER).to match_array(
        [
          :other
        ]
      )
    end
  end

  describe 'ALL_ORDERS' do
    it 'returns the expected array' do
      expect(described_class::ALL_ORDERS).to match_array(
        [
          :child_home,
          :child_times,
          :child_contact,
          :child_specific_issue_school,
          :child_specific_issue_religion,
          :child_specific_issue_name,
          :child_specific_issue_medical,
          :child_specific_issue_abroad,
          :child_return,
          :child_abduction,
          :child_flight,
          :other
        ]
      )
    end
  end
end
