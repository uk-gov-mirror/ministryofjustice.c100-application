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

  describe '#child_arrangements_orders' do
    it 'only returns the orders set to true' do
      expect(subject.child_arrangements_orders).to eq(
        [
          PetitionOrder.new(:child_home)
        ]
      )
    end
  end

  describe '#specific_issues_orders' do
    it 'only returns the orders set to true' do
      expect(subject.specific_issues_orders).to eq(
        [
          PetitionOrder.new(:child_specific_issue_religion),
          PetitionOrder.new(:child_specific_issue_medical)
        ]
      )
    end
  end

  describe '#prohibited_steps_orders' do
    it 'only returns the orders set to true' do
      expect(subject.prohibited_steps_orders).to eq(
        [
          PetitionOrder.new(:child_flight)
        ]
      )
    end
  end

  describe '#all_selected_orders' do
    it 'only returns the orders set to true' do
      expect(subject.all_selected_orders).to eq(
       [
         PetitionOrder.new(:child_home),
         PetitionOrder.new(:child_specific_issue_religion),
         PetitionOrder.new(:child_specific_issue_medical),
         PetitionOrder.new(:child_flight)
       ]
      )
    end
  end
end
