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

      context '`Address` struct convenience methods' do
        let(:result) { subject[0] }

        context '#address_lines' do
          it 'returns only the address lines' do
            expect(result.address_lines).to eq('APARTMENT 1001, 4, WIVERTON TOWER, NEW DRUM STREET')
          end
        end

        context '#tokenized_value' do
          it 'returns all address details in a tokenized string' do
            expect(result.tokenized_value).to eq('APARTMENT 1001, 4, WIVERTON TOWER|NEW DRUM STREET|LONDON|United Kingdom|E1 7AS')
          end
        end
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
