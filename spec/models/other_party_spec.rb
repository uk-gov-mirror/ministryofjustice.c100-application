require 'rails_helper'

RSpec.describe OtherParty, type: :model do
  subject { other_party }

  let(:other_party) do
    OtherParty.new(address_data: address_hash)
  end

  let(:address_hash) do
    {
      address_line_1: address_line_1,
      address_line_2: address_line_2,
      town: town,
      country: country,
      postcode: postcode
    }
  end

  let(:address_line_1) { nil }
  let(:address_line_2) { nil }
  let(:town) { nil }
  let(:country) { nil }
  let(:postcode) { nil }

  describe '#address_line_1' do
    context 'for a applicant with address_line_1 attributes' do
      let(:address_line_1) { 'address_line_1' }
      it { expect(subject.address_line_1).to eq(address_line_1) }
    end

    context 'when address_line_1 attributes is not set' do
      it { expect(subject.address_line_1).to eq(nil) }
    end
  end

  describe '#address_line_1=' do
    context 'for a applicant with address_line_1 attributes' do
      let(:address_line_1) { 'address_line_1' }
      it "provides the student's current address" do
        expect(subject.address_line_1).to eq(address_line_1)
        subject.address_line_1 = 'text'
        expect(subject.address_line_1).to eq('text')
      end
    end
  end
end
