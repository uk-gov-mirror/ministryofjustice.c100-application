require 'spec_helper'

module Summary
  describe Sections::ChildrenRelationships do
    let(:c100_application) {
      instance_double(C100Application,
        children: [],
        applicants: applicants,
        respondents: respondents,
        other_parties: other_parties,
      )
    }

    let(:applicants) { double('applicants') }
    let(:respondents) { double('respondents') }
    let(:other_parties) { double('other_parties') }
    let(:residence) { instance_double(ChildResidence) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:children_relationships)
      end
    end

    describe '#answers' do
      before do
        allow_any_instance_of(
          RelationshipsPresenter
        ).to receive(:relationship_to_children).with(applicants).and_return('applicants_relationships')

        allow_any_instance_of(
          RelationshipsPresenter
        ).to receive(:relationship_to_children).with(respondents).and_return('respondents_relationships')

        allow_any_instance_of(
          RelationshipsPresenter
        ).to receive(:relationship_to_children).with(other_parties).and_return('other_parties_relationships')

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
        expect(answers[0].value).to eq('applicants_relationships')

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:respondents_relationships)
        expect(answers[1].value).to eq('respondents_relationships')

        expect(answers[2]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[2].question).to eq(:other_parties_relationships)
        expect(answers[2].value).to eq('other_parties_relationships')

        expect(answers[3]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[3].question).to eq(:children_residence)
        expect(answers[3].value).to eq('Full name')
        expect(subject).to have_received(:residence_full_names)
      end
    end
  end
end
