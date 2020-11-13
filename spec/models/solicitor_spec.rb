require 'rails_helper'

RSpec.describe Solicitor, type: :model do
  subject { solicitor }

  let(:address_hash) do
    {
      address_line_1: 'address_line_1',
      address_line_2: '',
      town: 'town',
      country: 'country',
      postcode: 'postcode'
    }
  end

  let(:address_string) { 'address' }

  describe '#full_address' do
    let(:solicitor) { Solicitor.new(address: address_string, address_data: address_hash) }

    context 'when we have old `address` but not new `address_data`' do
      let(:address_hash) { {} }
      it { expect(subject.full_address).to eq('address') }
    end

    context 'when we have old `address` and also new `address_data`' do
      it { expect(subject.full_address).to eq('address_line_1, town, country, postcode') }
    end

    context 'when we only have new `address_data`' do
      let(:address_string) { nil }

      it { expect(subject.full_address).to eq('address_line_1, town, country, postcode') }

      context 'when the hash keys are in a different order or missing' do
        let(:address_hash) do
          {
            postcode: 'postcode',
            country: 'country',
            address_line_1: 'address_line_1',
            town: 'town',
          }
        end

        it 'returns the value in the expected order' do
          expect(subject.full_address).to eq('address_line_1, town, country, postcode')
        end
      end
    end
  end
end
