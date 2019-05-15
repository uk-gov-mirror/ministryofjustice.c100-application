require 'rails_helper'

RSpec.describe C100App::MapAddressLookupResults do
  let(:results) { [] }
  subject { described_class.call(results) }

  context '#call' do
    context 'with results' do
      let(:parsed_body) { JSON.parse(file_fixture('address_lookups/success.json').read) }
      let(:results) { parsed_body['results'] }
      it 'retrieves the address return by api' do
        expect(subject.size).to eq(3)

        expect(subject[0].address_line_1).to eq('APARTMENT 1001, 4, WIVERTON TOWER')
        expect(subject[0].address_line_2).to eq('NEW DRUM STREET')
        expect(subject[0].town).to eq('LONDON')
        expect(subject[0].country).to eq('United Kingdom')
        expect(subject[0].postcode).to eq('E1 7AS')
      end
    end

    context 'with no results' do
      it 'retrieves the address return by api' do
        expect(subject.size).to eq(0)
        expect(subject).to eq([])
      end
    end
  end

  context '#address_line' do
    let(:address) { ["", "address line 1", "somewhere", ""]}
    it 'return a string with no blank sections' do
      expect(described_class.address_line(address)).to eq('address line 1, somewhere')
    end
  end
end
