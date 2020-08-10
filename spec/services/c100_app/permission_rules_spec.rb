require 'rails_helper'

RSpec.describe C100App::PermissionRules do
  subject { described_class.new(relationship) }

  let(:relationship) { instance_double(Relationship, minor: child, relation: relation) }
  let(:child) { instance_double(Child, special_guardianship_order: sgo_order) }

  let(:sgo_order) { nil }
  let(:relation)  { 'father' }

  describe '#permission_needed?' do
    context 'when `special_guardianship_order` is `nil`' do
      it 'returns false' do
        expect(subject.permission_needed?).to eq(false)
      end
    end

    context 'when `special_guardianship_order` is `no`' do
      let(:sgo_order) { 'no' }

      it 'returns false' do
        expect(subject.permission_needed?).to eq(false)
      end
    end

    context 'when `special_guardianship_order` is `yes`' do
      let(:sgo_order) { 'yes' }

      it 'returns true' do
        expect(subject.permission_needed?).to eq(true)
      end
    end
  end

  describe '#permission_undecided?' do
    context 'when `special_guardianship_order` is `nil`' do
      it 'returns false' do
        expect(subject.permission_undecided?).to eq(false)
      end
    end

    context 'when `special_guardianship_order` is `no`' do
      let(:sgo_order) { 'no' }

      context 'when the relation is not `other`' do
        it 'returns false' do
          expect(subject.permission_undecided?).to eq(false)
        end
      end

      context 'when the relation is `other`' do
        let(:relation) { 'other' }

        it 'returns true' do
          expect(subject.permission_undecided?).to eq(true)
        end
      end
    end

    context 'when `special_guardianship_order` is `yes`' do
      let(:sgo_order) { 'yes' }

      context 'when the relation is not `other`' do
        it 'returns false' do
          expect(subject.permission_undecided?).to eq(false)
        end
      end

      context 'when the relation is `other`' do
        let(:relation) { 'other' }

        it 'returns true' do
          expect(subject.permission_undecided?).to eq(false)
        end
      end
    end
  end
end
