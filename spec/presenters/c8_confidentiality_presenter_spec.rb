require 'spec_helper'

RSpec.describe C8ConfidentialityPresenter do
  let(:c100_application) {
    C100Application.new(address_confidentiality: address_confidentiality)
  }

  let(:person) {
    Applicant.new(address: 'real address', residence_history: nil, gender: 'male')
  }

  describe 'constants' do
    it {
      expect(
        described_class::PEOPLE_UNDER_C8
      ).to contain_exactly(
        Applicant,
        OtherParty,
      )
    }

    it {
      expect(
        described_class::DETAILS_UNDER_C8
      ).to contain_exactly(
        :address,
        :residence_history,
        :home_phone,
        :mobile_phone,
        :email,
      )
    }
  end

  subject { described_class.new(person, c100_application) }

  describe 'Address confidentiality is enabled' do
    let(:address_confidentiality) { 'yes' }

    context 'for a person subject to C8' do
      it 'returns the replacement answer' do
        expect(subject.address).to eq('< See C8 attached >')
      end

      it 'returns the original answer if it is blank/nil' do
        expect(subject.residence_history).to eq(nil)
      end

      it 'returns the original answer when confidentiality does not apply' do
        expect(subject.gender).to eq('male')
      end
    end

    context 'for a person not subject to C8' do
      let(:person) { Respondent.new(address: 'real address') }

      it 'returns the original answer' do
        expect(subject.address).to eq('real address')
      end
    end
  end

  describe 'Address confidentiality is not enabled' do
    let(:address_confidentiality) { 'no' }

    it 'returns the original answer' do
      expect(subject.address).to eq('real address')
    end

    it 'returns the original answer if it is blank/nil' do
      expect(subject.residence_history).to eq(nil)
    end
  end
end
