require 'spec_helper'

RSpec.describe Steps::Shared::RelationshipForm do
  let(:arguments) { {
    c100_application: c100_application,
    record: record,
    relation: relation,
    relation_other_value: relation_other_value
  } }

  let(:c100_application) { instance_double(C100Application) }

  let(:record) { double('Relationship') }
  let(:relation) { 'mother' }
  let(:relation_other_value) { nil }

  subject { described_class.new(arguments) }


  describe '.choices' do
    it 'returns the relevant choices' do
      expect(described_class.choices).to eq(%w(
        mother
        father
        other
      ))
    end
  end

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'validations on field presence' do
      it { should validate_presence_of(:relation, :inclusion) }
    end

    context 'validations on `relation_other_value`' do
      context 'when relation is `other` and `relation_other_value` is not provided' do
        let(:relation) { 'other' }

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the `relation_other_value` field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:relation_other_value]).to_not be_empty
        end
      end

      context 'when relation is `other` and `relation_other_value` is provided' do
        let(:relation) { 'other' }
        let(:relation_other_value) { 'anything' }

        it 'has no validation errors' do
          expect(subject).to be_valid
        end
      end
    end

    context 'for valid details' do
      let(:relation_other_value) { 'anything' }

      it 'updates the record' do
        expect(record).to receive(:update).with(
          relation: Relation::MOTHER,
          relation_other_value: nil
        ).and_return(true)

        expect(subject.save).to be(true)
      end

      context 'for `other` relation' do
        let(:relation) { 'other' }

        it 'updates the record' do
          expect(record).to receive(:update).with(
            relation: Relation::OTHER,
            relation_other_value: 'anything'
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
