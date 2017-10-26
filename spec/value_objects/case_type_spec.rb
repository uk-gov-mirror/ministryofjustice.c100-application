require 'rails_helper'

RSpec.describe CaseType do
  let(:type) { :foo }
  subject    { described_class.new(type) }

  describe '.values' do
    it 'returns all case types' do
      expect(described_class.values.map(&:to_s)).to eq(%w(
        child_arrangements
        prohibited_steps
        specific_issue
      ))
    end
  end
end
