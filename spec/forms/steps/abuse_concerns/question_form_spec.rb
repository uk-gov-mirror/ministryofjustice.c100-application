require 'spec_helper'

RSpec.describe Steps::AbuseConcerns::QuestionForm do
  let(:arguments) { {
    c100_application: c100_application,
    subject: abuse_subject,
    kind: abuse_kind,
    answer: abuse_answer,
  } }

  let(:c100_application) { instance_double(C100Application, abuse_concerns: concerns_collection) }
  let(:concerns_collection) { double('concerns_collection') }
  let(:abuse_concern) { double('abuse_concern') }

  let(:abuse_subject) { 'applicant' }
  let(:abuse_kind)    { 'emotional' }
  let(:abuse_answer)  { 'no' }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'returns the relevant choices' do
      expect(described_class.choices).to eq(%w(yes no))
    end
  end

  describe '.i18n_key' do
    context 'for an applicant subject' do
      let(:abuse_subject) { 'applicant' }
      it { expect(subject.i18n_key).to eq('applicant.emotional') }
    end

    context 'for a children subject' do
      let(:abuse_subject) { 'children' }
      it { expect(subject.i18n_key).to eq('children.emotional') }
    end
  end

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'answer' do
      context 'when attribute is not given' do
        let(:abuse_answer) { nil }

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:answer]).to_not be_empty
        end
      end

      context 'when attribute value is not valid' do
        let(:abuse_answer) {'INVALID VALUE'}

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:answer]).to_not be_empty
        end
      end
    end

    context 'validations on field presence' do
      it { should validate_presence_of(:answer, :inclusion) }
      it { should validate_presence_of(:subject, :inclusion) }
      it { should validate_presence_of(:kind, :inclusion) }
    end

    context 'for valid details' do
      it 'creates the record if it does not exist' do
        expect(concerns_collection).to receive(:find_or_initialize_by).with(
          subject: AbuseSubject::APPLICANT,
          kind: AbuseType::EMOTIONAL
        ).and_return(abuse_concern)

        expect(abuse_concern).to receive(:update).with(
          answer: GenericYesNo::NO
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
