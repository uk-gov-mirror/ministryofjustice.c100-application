require 'rails_helper'

RSpec.describe ScreenerAnswers, type: :model do
  subject { described_class.new(local_court: local_court) }

  let(:local_court) { nil }

  describe '.attributes_to_validate' do
    it 'returns only the attributes that should be validated' do
      expect(
        described_class.attributes_to_validate
      ).to match_array(%w(
        children_postcodes
        local_court
        parent
        over18
        written_agreement
        email_consent
        legal_representation
      ))
    end
  end

  describe 'validations' do
    # One example for an attribute is enough as we have already another test
    # for all the attributes that will be run through the validator.
    #
    context 'when context is `completion`' do
      it { should validate_presence_of(:parent, :blank).on_context(:completion) }
    end

    context 'when context is not `completion`' do
      it { should_not validate_presence_of(:parent, :blank) }
    end
  end

  describe '#court' do
    context 'when there is a local_court' do
      let(:local_court) { { "name" => 'whatever' } }

      it 'returns a Court' do
        expect(Court).to receive(:new).with(local_court)
        subject.court
      end
    end

    context 'when there is no local_court' do
      it 'returns nil' do
        expect(subject.court).to eq(nil)
      end
    end
  end
end
