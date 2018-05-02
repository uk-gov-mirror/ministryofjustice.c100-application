require 'spec_helper'

module Summary
  describe HtmlSections::OtherChildrenDetails do
    subject { described_class.new(c100_application) }

    let(:c100_application) {
      instance_double(C100Application,
        other_children: [other_child],
        applicants: [],
        respondents: [],
        has_other_children: 'yes',
      )
    }

    let(:other_child) {
      instance_double(OtherChild,
        id: '5678',
        full_name: 'other name',
        dob: dob,
        age_estimate: age_estimate,
        gender: 'male',
        relationships: relationships,
      )
    }

    let(:dob) { Date.new(2018, 1, 20) }
    let(:age_estimate) { nil }

    let(:answers) { subject.answers }
    let(:relationships) { double('relationships') }

    describe '#name' do
      it 'is :other_children_details' do
        expect(subject.name).to eq(:other_children_details)
      end
    end

    describe '#answers' do
      before do
        allow(subject).to receive(:first_related_person_id).and_return('abcd')
        allow(subject).to receive(:relation_to_child).and_return('mother')
        allow(subject).to receive(:relationship).and_return(relationships)
      end

      it 'has the correct number of rows' do
        expect(answers.count).to eq(6)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(Separator)
        expect(answers[0].title).to eq(:other_child_index_title)
        expect(answers[0].i18n_opts).to eq({index: 1})

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:child_full_name)
        expect(answers[1].value).to eq('other name')
        expect(answers[1].change_path).to eq('/steps/other_children/names')

        expect(answers[2]).to be_an_instance_of(DateAnswer)
        expect(answers[2].question).to eq(:child_dob)
        expect(answers[2].value).to eq(Date.new(2018, 1, 20))
        expect(answers[2].change_path).to eq('/steps/other_children/personal_details/5678#steps_children_personal_details_form_dob_dd')

        expect(answers[3]).to be_an_instance_of(Answer)
        expect(answers[3].question).to eq(:child_sex)
        expect(answers[3].value).to eq('male')
        expect(answers[3].change_path).to eq('/steps/other_children/personal_details/5678#steps_children_personal_details_form_gender_female')

        expect(answers[4]).to be_an_instance_of(MultiAnswer)
        expect(answers[4].question).to eq(:child_applicants_relationship)
        expect(answers[4].value).to eq('mother')
        expect(c100_application).to have_received(:applicants).at_least(:once)
        expect(answers[4].change_path).to eq("/steps/applicant/relationship/abcd/child/5678")

        expect(answers[5]).to be_an_instance_of(MultiAnswer)
        expect(answers[5].question).to eq(:child_respondents_relationship)
        expect(answers[5].value).to eq('mother')
        expect(c100_application).to have_received(:respondents).at_least(:once)
        expect(answers[5].change_path).to eq("/steps/respondent/relationship/abcd/child/5678")
      end
    end
  end
end
