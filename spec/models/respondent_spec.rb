require 'rails_helper'

RSpec.describe Respondent, type: :model do
  subject { respondent }

 let(:address_string) { 'address' }


  let(:respondent) do
    Respondent.new(address: address_string)
  end

  let(:address_string) { 'address' }
  describe '#full_address' do
    context 'return address' do
      it { expect(subject.full_address).to eq(address_string) }
    end
  end
end
