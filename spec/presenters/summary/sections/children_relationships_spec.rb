require 'spec_helper'

module Summary
  describe Sections::ChildrenRelationships do
    let(:c100_application) {
      instance_double(C100Application,
        applicants: applicants,
        respondents: respondents,
        other_parties: other_parties,
        relationships: relationships_scope,
      )
    }

    let(:applicants) { double('applicants') }
    let(:respondents) { double('respondents') }
    let(:other_parties) { double('other_parties') }

    let(:relationships_scope) { double('relationships', with_permission_data: relationships) }
    let(:relationships) { [] }

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
      end

      it 'has the correct number of rows' do
        expect(answers.count).to eq(4)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[0].question).to eq(:applicants_relationships)
        expect(answers[0].value).to eq('applicants_relationships')

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:respondents_relationships)
        expect(answers[1].value).to eq('respondents_relationships')

        expect(answers[2]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[2].question).to eq(:other_parties_relationships)
        expect(answers[2].value).to eq('other_parties_relationships')

        expect(answers[3]).to be_an_instance_of(Partial)
        expect(answers[3].name).to eq(:row_blank_space)
      end

      context 'when there are relationships with permission details' do
        let(:relationships) { [relationship1, relationship2] }

        let(:person) { instance_double(Applicant, full_name: 'Applicant Test') }
        let(:minor)  { instance_double(Child, full_name: 'Child Test') }

        let(:relationship1) {
          instance_double(
            Relationship,
            person: person,
            minor: minor,
            parental_responsibility: 'no',
            living_order: 'yes',
            amendment: nil,
            time_order: nil,
            living_arrangement: nil,
            consent: nil,
            family: nil,
            local_authority: nil,
            relative: nil,
          )
        }

        let(:relationship2) {
          instance_double(
            Relationship,
            person: person,
            minor: minor,
            parental_responsibility: 'no',
            living_order: 'no',
            amendment: 'no',
            time_order: 'yes',
            living_arrangement: nil,
            consent: nil,
            family: nil,
            local_authority: nil,
            relative: nil,
          )
        }

        it 'has the correct number of rows' do
          expect(answers.count).to eq(7)
        end

        it 'has the correct rows in the right order' do
          expect(answers[0]).to be_an_instance_of(FreeTextAnswer)
          expect(answers[0].question).to eq(:applicants_relationships)
          expect(answers[0].value).to eq('applicants_relationships')

          expect(answers[1]).to be_an_instance_of(Answer)
          expect(answers[1].question).to eq('child_permission_living_order')
          expect(answers[1].value).to eq('yes')
          expect(answers[1].i18n_opts).to eq({ applicant_name: 'Applicant Test', child_name: 'Child Test'})

          expect(answers[2]).to be_an_instance_of(Answer)
          expect(answers[2].question).to eq('child_permission_time_order')
          expect(answers[2].value).to eq('yes')
          expect(answers[2].i18n_opts).to eq({ applicant_name: 'Applicant Test', child_name: 'Child Test'})

          expect(answers[3]).to be_an_instance_of(Partial)
          expect(answers[3].name).to eq(:row_blank_space)
        end
      end
    end
  end
end
