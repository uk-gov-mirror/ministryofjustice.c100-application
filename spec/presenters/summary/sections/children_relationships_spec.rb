require 'spec_helper'

module Summary
  describe Sections::ChildrenRelationships do
    let(:c100_application) {
      instance_double(C100Application,
        children: [],
        applicants: [],
        respondents: [],
        other_parties: [],
        relationships: relationships,
      )
    }

    let(:relationships) { double('relationships') }
    let(:relationship)  { instance_double(Relationship) }
    let(:residence)     { instance_double(ChildResidence) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:children_relationships)
      end
    end

    describe '#answers' do
      before do
        allow(relationships).to receive(:where).and_return([relationship])

        allow(relationship).to receive(:relation).and_return('whatever')
        allow(relationship).to receive(:person).and_return(double(full_name: 'person name'))
        allow(relationship).to receive(:child).and_return(double(full_name: 'child name'))

        allow(I18n).to receive(:translate!).with('whatever', {scope: 'dictionary.RELATIONS'}).and_return('Whatever')

        # This is a quick smoke test, not in deep, as we are probably need to change the
        # implementation of the residence_full_names method once the PDF mockup is finished.
        allow(ChildResidence).to receive(:where).and_return([residence])
        allow(subject).to receive(:residence_full_names).with(residence).and_return('Full name')
      end

      it 'has the correct number of rows' do
        expect(answers.count).to eq(4)
      end

      it 'has the correct rows in the right order' do
        expect(c100_application).to receive(:children)

        expect(answers[0]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[0].question).to eq(:applicants_relationships)
        expect(answers[0].value).to eq('person name - Whatever - child name')
        expect(c100_application).to have_received(:applicants)

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:respondents_relationships)
        expect(answers[1].value).to eq('person name - Whatever - child name')
        expect(c100_application).to have_received(:respondents)

        expect(answers[2]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[2].question).to eq(:other_parties_relationships)
        expect(answers[2].value).to eq('person name - Whatever - child name')
        expect(c100_application).to have_received(:other_parties)

        expect(answers[3]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[3].question).to eq(:children_residence)
        expect(answers[3].value).to eq('Full name')
        expect(subject).to have_received(:residence_full_names)
      end

      context 'when relation is `other`' do
        before do
          allow(relationship).to receive(:relation).and_return('other')
          allow(relationship).to receive(:relation_other_value).and_return('a friend')
        end

        it 'renders the `relation_other_value`' do
          expect(answers[0].value).to eq('person name - a friend - child name')
        end
      end
    end
  end
end
