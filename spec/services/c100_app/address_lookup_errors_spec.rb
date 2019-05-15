require 'rails_helper'

RSpec.describe C100App::AddressLookupErrors do
  let(:errors) { C100App::AddressLookupErrors.new }

  describe '#add' do
    before do
      errors.add :some_error, 'some error description'
    end

    it 'adds the error' do
      expect(errors[:some_error]).to eq(['some error description'])
    end

    it 'adds the same error only once' do
      errors.add :some_error, 'some error description'
      expect(errors[:some_error]).to eq(['some error description'])
    end
  end

  describe '#each' do
    before do
      errors.add :error_one, 'one error description'
      errors.add :error_two, 'one error description'
      errors.add :error_two, 'two errors description'
    end

    it 'yields each message for the same key independently' do
      expect { |b| errors.each(&b) }.to yield_control.exactly(3).times
      expect { |b| errors.each(&b) }.to yield_successive_args(
        [:error_one, 'one error description'],
        [:error_two, 'one error description'],
        [:error_two, 'two errors description']
      )
    end
  end

  describe '#full_messages' do
    before do
      errors.add :attr1, 'has an error'
      errors.add :attr2, 'has an error'
      errors.add :attr2, 'has two errors'
    end

    it "returrns the full messages array" do
      expect(errors.full_messages).to eq ["Attr1 has an error", "Attr2 has an error", "Attr2 has two errors"]
    end
  end
end
