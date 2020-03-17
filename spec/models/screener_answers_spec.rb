require 'rails_helper'

RSpec.describe ScreenerAnswers, type: :model do
  subject { described_class.new(local_court: local_court) }

  let(:local_court) { nil }

  describe '.attributes_to_validate' do
    it 'returns only the attributes that should be validated' do
      expect(
        described_class.attributes_to_validate
      ).to match_array(%w(
        id
        c100_application_id
        children_postcodes
        local_court
        parent
        written_agreement
        email_consent
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

  describe '#refresh_local_court!' do
    before do
      allow(subject).to receive(:children_postcodes).and_return('ABC 123')
    end

    context 'when at least one court was found' do
      it 'updates the local court' do
        expect_any_instance_of(
          C100App::CourtPostcodeChecker
        ).to receive(:courts_for).with('ABC 123').and_return(%w(foobar another))

        expect(Court).to receive(:new).with('foobar').and_return('foobar')
        expect(subject).to receive(:update_column).with(:local_court, 'foobar')
        subject.refresh_local_court!
      end
    end

    context 'when no courts were found' do
      let(:court_results) { [] }

      it 'returns without any update' do
        expect_any_instance_of(
          C100App::CourtPostcodeChecker
        ).to receive(:courts_for).with('ABC 123').and_return([])

        expect(subject).not_to receive(:update_column)
        subject.refresh_local_court!
      end
    end
  end
end
