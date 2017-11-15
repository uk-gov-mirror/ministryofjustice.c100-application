require 'spec_helper'

RSpec.describe Steps::CourtOrders::HasOrdersForm do
  let(:arguments) { {
    c100_application: c100_application,
    has_court_orders: has_court_orders
  } }
  let(:c100_application) { instance_double(C100Application, has_court_orders: nil) }
  let(:has_court_orders) { 'no' }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'returns the relevant choices' do
      expect(described_class.choices).to eq(%w(yes no))
    end
  end

  describe '#save' do
    it_behaves_like 'a value object form', attribute_name: :has_court_orders, example_value: 'no'

    context 'validations on field presence' do
      it { should validate_presence_of(:has_court_orders, :inclusion) }
    end

    context 'when has_court_orders is valid' do
      it 'saves the record' do
        expect(c100_application).to receive(:update).with(
          has_court_orders: GenericYesNo::NO
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end
  end
end
