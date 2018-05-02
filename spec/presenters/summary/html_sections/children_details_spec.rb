require 'spec_helper'

module Summary
  describe HtmlSections::ChildrenDetails do
    let(:c100_application) {
      instance_double(C100Application,
        children: [child],
        other_children: [],
        applicants: [],
        respondents: [],
        children_known_to_authorities: 'yes',
        children_known_to_authorities_details: 'details',
        children_protection_plan: 'no',
        has_other_children: 'yes',
      )
    }

    let(:child) {
      instance_double(Child,
        id: '1234',
        full_name: 'name',
        dob: dob,
        age_estimate: age_estimate,
        gender: 'female',
        child_order: child_order,
        relationships: relationships,
      )
    }

    let(:dob) { Date.new(2018, 1, 20) }
    let(:age_estimate) { nil }
    let(:child_order) { instance_double(ChildOrder, orders: ['an_order']) }
    let(:relationship){ instance_double(Relationship, relation: 'mother') }
    let(:relationships) do
      double('relationships', pluck: relationship, first: relationship)
    end

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:children_details)
      end
    end

    # The following tests can be fragile, but on purpose. During the development phase
    # we have to update the tests each time we introduce a new row or remove another.
    # But once it is finished and stable, it will raise a red flag if it ever gets out
    # of sync, which means a quite solid safety net for any maintainers in the future.
    #
    describe '#answers' do
      before do
        allow(subject).to receive(:first_related_person_id).and_return('5678')
        allow(subject).to receive(:relation_to_child).and_return('mother')
        allow(subject).to receive(:relationship).and_return(relationships)
      end

      it 'has the correct number of rows' do
        expect(answers.count).to eq(11)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(Separator)
        expect(answers[0].title).to eq(:child_index_title)
        expect(answers[0].i18n_opts).to eq({index: 1})

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:child_full_name)
        expect(answers[1].value).to eq('name')
        expect(answers[1].change_path).to eq('/steps/children/names')

        expect(answers[2]).to be_an_instance_of(DateAnswer)
        expect(answers[2].question).to eq(:child_dob)
        expect(answers[2].value).to eq(Date.new(2018, 1, 20))
        expect(answers[2].change_path).to eq('/steps/children/personal_details/1234#steps_children_personal_details_form_dob_dd')

        expect(answers[3]).to be_an_instance_of(Answer)
        expect(answers[3].question).to eq(:child_sex)
        expect(answers[3].value).to eq('female')
        expect(answers[3].change_path).to eq('/steps/children/personal_details/1234#steps_children_personal_details_form_gender_female')

        expect(answers[4]).to be_an_instance_of(MultiAnswer)
        expect(answers[4].question).to eq(:child_applicants_relationship)
        expect(answers[4].value).to eq('mother')
        expect(c100_application).to have_received(:applicants).at_least(:once)
        expect(answers[4].change_path).to eq("/steps/applicant/relationship/5678/child/1234")

        expect(answers[5]).to be_an_instance_of(MultiAnswer)
        expect(answers[5].question).to eq(:child_respondents_relationship)
        expect(answers[5].value).to eq('mother')
        expect(c100_application).to have_received(:respondents).at_least(:once)
        expect(answers[5].change_path).to eq("/steps/respondent/relationship/5678/child/1234")

        expect(answers[6]).to be_an_instance_of(MultiAnswer)
        expect(answers[6].question).to eq(:child_orders)
        expect(answers[6].value).to eq(['other_issue'])
        expect(answers[6].change_path).to eq('/steps/children/orders/1234')

        expect(answers[7]).to be_an_instance_of(Answer)
        expect(answers[7].question).to eq(:children_known_to_authorities)
        expect(c100_application).to have_received(:children_known_to_authorities)
        expect(answers[7].change_path).to eq('/steps/children/additional_details')


        expect(answers[8]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[8].question).to eq(:children_known_to_authorities_details)
        expect(c100_application).to have_received(:children_known_to_authorities_details)
        expect(answers[8].change_path).to eq('/steps/children/additional_details')

        expect(answers[9]).to be_an_instance_of(Answer)
        expect(answers[9].question).to eq(:children_protection_plan)
        expect(c100_application).to have_received(:children_protection_plan)
        expect(answers[9].change_path).to eq('/steps/children/additional_details')


        expect(answers[10]).to be_an_instance_of(Answer)
        expect(answers[10].question).to eq(:has_other_children)
        expect(c100_application).to have_received(:has_other_children)
        expect(answers[10].change_path).to eq('/steps/children/has_other_children')

      end

      context 'when `dob` is nil' do
        let(:dob) { nil }
        let(:age_estimate) { 18 }

        it 'uses the age estimate' do
          expect(answers[2]).to be_an_instance_of(FreeTextAnswer)
          expect(answers[2].question).to eq(:child_age_estimate)
          expect(answers[2].value).to eq(18)
        end
      end
    end
  end
end
