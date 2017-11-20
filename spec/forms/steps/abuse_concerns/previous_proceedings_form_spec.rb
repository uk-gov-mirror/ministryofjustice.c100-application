require 'spec_helper'

RSpec.describe Steps::AbuseConcerns::PreviousProceedingsForm do
  let(:arguments) { {
    c100_application: c100_application,
    children_previous_proceedings: children_previous_proceedings
  } }
  let(:c100_application) { instance_double(C100Application) }
  let(:children_previous_proceedings) { 'yes' }

  subject { described_class.new(arguments) }

  describe '#save' do
    it_behaves_like 'a value object form', attribute_name: :children_previous_proceedings, example_value: 'yes'

    context 'validations on field presence' do
      it { should validate_presence_of(:children_previous_proceedings, :inclusion) }
    end

    context 'when previous_proceedings is valid' do
      let(:children_previous_proceedings) { 'yes' }

      it 'saves the record' do
        expect(c100_application).to receive(:update).with(
          children_previous_proceedings: GenericYesNo::YES
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end
  end
end
