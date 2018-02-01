require 'spec_helper'

RSpec.describe RelationshipsPresenter do
  let(:c100_application) { instance_double(C100Application, children: children, relationships: relationships) }

  let(:children) { [] }
  let(:relationships) { double('relationships') }
  let(:child_relationship) { double(Relationship) }

  subject { described_class.new(c100_application) }

  describe '#relationship_to_children' do
    let(:person) { instance_double(Person, relationships: relationships) }

    before do
      allow(relationships).to receive(:where).with(child: children, person: person).and_return([child_relationship])

      allow(child_relationship).to receive(:relation).and_return('father')
      allow(child_relationship).to receive(:child).and_return(double(full_name: 'Child name'))
      allow(child_relationship).to receive(:person).and_return(double(full_name: 'Person name'))
    end

    context 'showing the person name' do
      it 'returns a string describing the relationships' do
        expect(subject.relationship_to_children(person, show_person_name: true)).to eq('Person name - Father - Child name')
      end
    end

    context 'hiding the person name' do
      it 'returns a string describing the relationships' do
        expect(subject.relationship_to_children(person, show_person_name: false)).to eq('Father - Child name')
      end
    end

    context 'for `other` relationship' do
      before do
        allow(child_relationship).to receive(:relation).and_return('other')
        allow(child_relationship).to receive(:relation_other_value).and_return('A friend')
      end

      context 'showing the person name' do
        it 'returns a string describing the relationships' do
          expect(subject.relationship_to_children(person, show_person_name: true)).to eq('Person name - A friend - Child name')
        end
      end

      context 'hiding the person name' do
        it 'returns a string describing the relationships' do
          expect(subject.relationship_to_children(person, show_person_name: false)).to eq('A friend - Child name')
        end
      end
    end
  end
end
