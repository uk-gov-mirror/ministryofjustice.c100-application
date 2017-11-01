require 'spec_helper'

RSpec.describe Steps::HelpWithFees::HelpPayingForm do
  let(:arguments) { {
    c100_application: c100_application,
    help_paying: help_paying,
    hwf_reference_number: hwf_reference_number
  } }
  let(:c100_application) { instance_double(C100Application, help_paying: nil, hwf_reference_number: nil) }
  let(:help_paying) { nil }
  let(:hwf_reference_number) { nil }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'returns the relevant choices' do
      expect(described_class.choices).to eq(%w(
        yes_with_ref_number
        yes_without_ref_number
        not_needed
      ))
    end
  end

  describe '#save' do
    it_behaves_like 'a value object form', attribute_name: :help_paying, example_value: 'not_needed'

    context 'when help_paying is valid' do
      let(:help_paying) { 'not_needed' }

      it 'saves the record' do
        expect(c100_application).to receive(:update).with(
          help_paying: HelpPaying::NOT_NEEDED,
          hwf_reference_number: nil
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when help_paying is already the same on the model' do
      let(:c100_application) {
        instance_double(
          C100Application,
          help_paying: HelpPaying::YES_WITH_REF_NUMBER,
          hwf_reference_number: '12345-X'
        )
      }
      let(:help_paying) { 'yes_with_ref_number' }
      let(:hwf_reference_number) { '12345-X' }

      it 'does not save the record but returns true' do
        expect(c100_application).to_not receive(:update)
        expect(subject.save).to be(true)
      end

      # This is a mutant killer.
      it 'checks if the form should be saved or bypass the save' do
        expect(subject).to receive(:changed?).and_call_original
        expect(subject).to receive(:help_paying_value).and_call_original
        expect(subject).to receive(:hwf_reference_number).twice.and_call_original
        expect(c100_application).to receive(:hwf_reference_number)
        subject.save
      end
    end

    context 'for `yes_with_ref_number` option' do
      let(:help_paying) { 'yes_with_ref_number' }

      it { should validate_presence_of(:hwf_reference_number) }

      context 'when reference number is entered' do
        let(:hwf_reference_number) { '12345-X' }

        it 'saves the record' do
          expect(c100_application).to receive(:update).with(
            help_paying: HelpPaying::YES_WITH_REF_NUMBER,
            hwf_reference_number: '12345-X'
          ).and_return(true)
          expect(subject.save).to be(true)
        end
      end
    end
  end
end
