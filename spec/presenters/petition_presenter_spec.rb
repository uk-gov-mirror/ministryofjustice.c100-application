require 'spec_helper'

RSpec.describe PetitionPresenter do
  subject { described_class.new(asking_order) }

  let(:asking_order) { AskingOrder.new(asking_order_attributes) }
  let(:asking_order_attributes) {
    {
      child_home: true,
      child_times: false,
      child_contact: nil,
      child_specific_issue_school: false,
      child_specific_issue_religion: true,
      child_specific_issue_name: nil,
      child_specific_issue_medical: true,
      child_specific_issue_abroad: false,
      child_return: nil,
      child_abduction: false,
      child_flight: true
    }
  }

  describe 'orders map' do
    it 'returns the expected values for `child_arrangements`' do
      expect(PetitionPresenter::ORDERS[:child_arrangements]).to match_array(
        [:child_home, :child_times, :child_contact]
      )
    end

    it 'returns the expected values for `specific_issues_orders`' do
      expect(PetitionPresenter::ORDERS[:specific_issues]).to match_array(
        [:child_return, :child_specific_issue_abroad, :child_specific_issue_medical, :child_specific_issue_name, :child_specific_issue_religion, :child_specific_issue_school]
      )
    end

    it 'returns the expected values for `prohibited_steps_orders`' do
      expect(PetitionPresenter::ORDERS[:prohibited_steps]).to match_array(
        [:child_abduction, :child_flight]
      )
    end
  end

  describe '#child_arrangements_orders' do
    it 'only returns the orders set to true' do
      expect(subject.child_arrangements_orders).to match_array([:child_home])
    end
  end

  describe '#specific_issues_orders' do
    it 'only returns the orders set to true' do
      expect(subject.specific_issues_orders).to match_array([:child_specific_issue_medical, :child_specific_issue_religion])
    end
  end

  describe '#prohibited_steps_orders' do
    it 'only returns the orders set to true' do
      expect(subject.prohibited_steps_orders).to match_array([:child_flight])
    end
  end
end
