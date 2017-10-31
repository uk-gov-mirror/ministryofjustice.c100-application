require 'spec_helper'

RSpec.describe Steps::HelpWithFees::HelpPayingForm do
  let(:arguments) { {
    c100_application: c100_application,
    help_paying: help_paying
  } }
  let(:c100_application) { instance_double(C100Application, help_paying: nil) }
  let(:help_paying) { nil }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'returns the relevant choices' do
      expect(described_class.choices).to eq(%w(
        yes
        no
      ))
    end
  end

  describe '#save' do
    it_behaves_like 'a value object form', attribute_name: :help_paying, example_value: 'yes'

    context 'when help_paying is valid' do
      let(:help_paying) { 'yes' }

      it 'saves the record' do
        expect(c100_application).to receive(:update).with(
          help_paying: HelpPaying::YES
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when help_paying is already the same on the model' do
      let(:c100_application) {
        instance_double(
          C100Application,
          help_paying: HelpPaying::YES
        )
      }
      let(:help_paying) { 'yes' }

      it 'does not save the record but returns true' do
        expect(subject).to receive(:help_paying_value).and_call_original
        expect(c100_application).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end
