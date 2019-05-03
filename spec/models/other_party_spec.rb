require 'rails_helper'

RSpec.describe OtherParty, type: :model do
  subject { other_party }

 let(:address_string) { 'address' }


  let(:other_party) do
    OtherParty.new(address: address_string)
  end

  let(:address_string) { 'address' }
  describe '#full_address' do
    context 'return address' do
      it { expect(subject.full_address).to eq(address_string) }
    end
  end
end
