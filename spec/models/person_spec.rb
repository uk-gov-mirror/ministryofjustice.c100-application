require 'rails_helper'

RSpec.describe Person, type: :model do
  subject { person }

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
  let(:split_address_value) { false }

  describe '#full_name' do
    let(:person) do
      Person.new(first_name: first_name, last_name: last_name)
    end

    let(:first_name) { nil }
    let(:last_name)  { nil }

    context 'for a person with first and last name attributes' do
      let(:first_name) { 'John' }
      let(:last_name) { 'Doe' }
      it { expect(subject.full_name).to eq('John Doe') }
    end

    context 'for a person with a first_name attribute' do
      let(:first_name) { 'John Doe' }
      it { expect(subject.full_name).to eq('John Doe') }
    end

    context 'for a person without a last_name attribute' do
      let(:last_name) { 'John Doe' }
      it { expect(subject.full_name).to eq('John Doe') }
    end
  end

  describe '#full_address' do
    let(:person) do
      Person.new(address: address_string, address_data: address_hash)
    end

    before do
      allow(subject).to receive(:split_address?).and_return(split_address_value)
    end

    context 'non split address' do
      it { expect(subject.full_address).to eq(address_string) }
    end

    context 'split address' do
      let(:split_address_value) { true }

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

  describe '#split_address?' do
    let(:version) { 2 }
    let(:c100_application) { C100Application.new(version: version) }

    let(:person) do
      Person.new(address: address_string, address_data: address_hash, c100_application: c100_application)
    end

    context 'return false' do
      it { expect(subject.split_address?).to eq(false) }
    end

    context 'return true' do
      context 'when version > 2' do
        context 'when version equal 3 'do
          let(:version) { 3 }
          it { expect(subject.split_address?).to eq(true) }
        end
      end
    end
  end
end
