require 'rails_helper'

module Test
  C100ApplicationValidatable = Struct.new(:screener_answers, :applicants, keyword_init: true) do
    include ActiveModel::Validations
    validates_with ApplicationFulfilmentValidator
  end
end

RSpec.describe ApplicationFulfilmentValidator, type: :model do
  subject { Test::C100ApplicationValidatable.new(arguments) }

  # TODO: feature-flag code, to be remove once released
  context 'validations are run based on feature flag' do
    let(:screener_answers) { instance_double(ScreenerAnswers, local_court: local_court) }
    let(:arguments) { { applicants: [] } }

    before do
      allow(subject).to receive(:screener_answers).and_return(screener_answers)
    end

    context 'when the court data is a fixture' do
      let(:local_court) { { "_fixture" => true } }

      it 'runs the validations' do
        expect(subject).not_to be_valid
      end
    end

    context 'when the court data is not a fixture' do
      let(:local_court) { {} }

      it 'does not run the validations' do
        expect(subject).to be_valid
      end
    end
  end

  describe 'applicants validation' do
    # TODO: feature-flag code, to be remove once released
    # Assume in following tests we must always validate
    before do
      allow_any_instance_of(described_class).to receive(:must_validate?).and_return(true)
    end

    context 'there are no applicants' do
      let(:arguments) { { applicants: [] } }

      it 'is invalid' do
        expect(subject).not_to be_valid
        expect(subject.errors.details[:applicants][0][:error]).to eq(:blank)
        expect(subject.errors.details[:applicants][0][:change_path]).to eq('/steps/applicant/names/')
      end
    end

    context 'there is at least one applicant' do
      let(:arguments) { { applicants: [Object] } }

      it 'is valid' do
        subject.valid?
        expect(subject.errors.details.include?(:applicants)).to eq(false)
      end
    end
  end
end
