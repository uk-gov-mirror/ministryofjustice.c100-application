require 'rails_helper'

describe Court do
  describe '#initialize' do
    let(:court){ Court.new(params) }
    context 'given a hash of key/value pairs' do
      let(:params){
        {name: 'my court', slug: 'my slug'}
      }

      it 'sets the values which match a Courts attributes' do
        expect(court.name).to eq(params[:name])
        expect(court.slug).to eq(params[:slug])
      end

      context 'containing a key which does not match a Court attribute' do
        let(:params){
          {name: 'my court', foo: 'bar'}
        }
        it 'does not get set' do
          expect(court.send(:instance_variable_get, '@foo')).to be_nil
        end
      end
    end

    context 'given no args' do
      let(:court){ Court.new }
      it 'returns a valid Court' do
        expect(court).to be_a(Court)
      end
    end
  end

  describe '#from_courtfinder_data!' do
    context 'given a hash' do
      let(:args){
        {}
      }
      let(:court){ Court.new }

      it 'calls parse_basic_attributes! with the given hash' do
        expect(court).to receive(:parse_basic_attributes!).with(args)
        court.from_courtfinder_data!(args)
      end

      it 'returns itself' do
        expect(court.from_courtfinder_data!(args)).to eq(court)
      end

      context 'including an address key' do
        let(:args){
          {'address' => 'my address'}
        }

        it 'calls parse_given_address! with the address value' do
          expect(court).to receive(:parse_given_address!).with('my address')
          court.from_courtfinder_data!(args)
        end
      end
    end
  end

  describe '#parse_basic_attributes!' do
    context 'given a hash' do
      let(:args){ {} }
      let(:court){ Court.new }
      before do
        court.parse_basic_attributes!(args)
      end

      context 'including name' do
        let(:args){ {'name' => 'my name'} }

        it 'sets the name attribute' do
          expect(court.name).to eq('my name')
        end
      end
      context 'including slug' do
        let(:args){ {'slug' => 'my slug'} }

        it 'sets the slug attribute' do
          expect(court.slug).to eq('my slug')
        end
      end

      context 'including number' do
        let(:args){ {'number' => 'my number'} }

        it 'sets the phone_number attribute' do
          expect(court.phone_number).to eq('my number')
        end
      end
    end
  end

  describe '#parse_given_address!' do
    context 'given a hash' do
      let(:args){ {} }
      let(:court){ Court.new }
      before do
        court.parse_given_address!(args)
      end

      context 'including address_lines' do
        let(:args){ {'address_lines' => 'my address_lines'} }

        it 'sets the address_lines attribute' do
          expect(court.address_lines).to eq('my address_lines')
        end
      end
      context 'including town' do
        let(:args){ {'town' => 'my town'} }

        it 'sets the town attribute' do
          expect(court.town).to eq('my town')
        end
      end

      context 'including postcode' do
        let(:args){ {'postcode' => 'my postcode'} }

        it 'sets the postcode attribute' do
          expect(court.postcode).to eq('my postcode')
        end
      end
    end
  end

  describe '#address' do
    subject{
      Court.new(address_lines: address_lines, town: 'town', postcode: 'postcode')
    }
    let(:address_lines){ ['line 1', 'line 2'] }

    it 'returns a flattened array of address_lines, town and postcode' do
      expect(subject.address).to eq(['line 1', 'line 2', 'town', 'postcode'])
    end

    context 'when any lines are duplicated' do
      let(:address_lines){ ['line 1', 'postcode'] }

      it 'removes the duplicates' do
        expect(subject.address).to eq(['line 1', 'postcode', 'town'])
      end
    end

    context 'when any lines are blank' do
      let(:address_lines){ ['line 1', ''] }

      it 'removes the blank lines' do
        expect(subject.address).to eq(['line 1', 'town', 'postcode'])
      end
    end
  end
end
