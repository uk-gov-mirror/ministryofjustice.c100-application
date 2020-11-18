require 'rails_helper'

RSpec.describe Solicitor, type: :model do
  it_behaves_like 'a model with structured address details'

  # TODO: we need to maintain backwards compatibility for some time
  describe '#full_address' do
    subject { described_class.new(address: address_string, address_data: address_hash) }

    let(:address_string) { 'address' }
    let(:address_hash) do
      {
        address_line_1: 'address_line_1',
        address_line_2: '',
        town: 'town',
        country: 'country',
        postcode: 'postcode'
      }
    end

    context 'when we have old `address` but not new `address_data`' do
      let(:address_hash) { {} }
      it { expect(subject.full_address).to eq('address') }
    end

    context 'when we have old `address` and also new `address_data`' do
      it { expect(subject.full_address).to eq('address_line_1, town, country, postcode') }
    end
  end
end
