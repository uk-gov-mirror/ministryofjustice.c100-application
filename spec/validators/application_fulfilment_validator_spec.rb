require 'rails_helper'

module Test
  C100ApplicationValidatable = Struct.new(:applicants, keyword_init: true) do
    include ActiveModel::Validations
    validates_with ApplicationFulfilmentValidator
  end
end

RSpec.describe ApplicationFulfilmentValidator, type: :model do
  subject { Test::C100ApplicationValidatable.new(arguments) }

  describe 'applicants validation' do
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
