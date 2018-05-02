require 'rails_helper'

describe Summary::HtmlSections::BaseChildrenDetails do
  let(:c100_application) { instance_double(C100Application, {}) }
  subject { described_class.new(c100_application) }

  describe '#edit_relation_path' do
    context 'given a Child' do
      let(:child) do
        instance_double(Child, id: 'my_child_id', relationships: relationships)
      end

      context 'with relationships' do
        let(:people) { ['person_id'] }
        let(:relationships) do
          instance_double('relationships', pluck: ['my_person_id'])
        end

        before do
          allow(subject).to receive(:relationship).and_return(relationships)
        end

        it 'gets the relationships between the given child and given people' do
          expect(subject).to receive(:relationship)
                             .with(child, people)
                             .and_return([])
          subject.send(:edit_relation_path, child, 'type', people)
        end

        describe 'the return value' do
          let(:value) { subject.send(:edit_relation_path, child, 'applicant', people) }

          it 'starts with /steps/applicant/relationship/' do
            expect(value).to start_with('/steps/applicant/relationship/')
          end

          it 'ends with (first relationship_id)/child/(child_id)' do
            expect(value).to end_with('my_person_id/child/my_child_id')
          end
        end
      end
    end
  end

  describe '#relationship' do
    let(:relationships){ double('relationships') }
    let(:child){ double('child', relationships: relationships) }
    let(:people){ double('people') }

    before do
      allow(relationships).to receive(:where)
                              .with(person: people)
                              .and_return('foo')
    end

    it 'gets the child relationships to the given people' do
      expect(relationships).to receive(:where).with(person: people)
      subject.send(:relationship, child, people)
    end

    it 'returns the relationships to the given people' do
      expect(subject.send(:relationship, child, people)).to eq('foo')
    end
  end

  describe '#relation_to_child' do
    let(:relationship){ double('relationship', pluck: 'plucked relation')}
    let(:child){ double('child') }
    let(:people){ double('people') }

    before do
      allow(subject).to receive(:relationship).and_return(relationship)
    end

    it 'calls relationship passing on the child & people' do
      expect(subject).to receive(:relationship)
                         .with(child, people)
                         .and_return(relationship)
      subject.send(:relation_to_child, child, people)
    end

    it 'plucks :relation from the relationship' do
      expect(relationship).to receive(:pluck)
                              .with(:relation)
                              .and_return('plucked relation')
      subject.send(:relation_to_child, child, people)
    end

    it 'returns the plucked relation' do
      expect(subject.send(:relation_to_child, child, people)).to eq('plucked relation')
    end
  end
end
