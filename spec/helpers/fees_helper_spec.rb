require 'rails_helper'

RSpec.describe FeesHelper, type: :helper do
  describe '#fee_amount' do
    it 'returns the localised version of the court fee' do
      expect(helper.fee_amount).to eq('£215')
    end
  end
end
