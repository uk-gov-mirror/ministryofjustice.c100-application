require 'spec_helper'

module Summary
  describe Sections::OtherChildrenDetails do
    let(:c100_application) {
      instance_double(C100Application,
        other_children: [other_child],
        applicants: [],
        respondents: [],
      )
    }

    let(:other_child) {
      instance_double(OtherChild,
        full_name: 'name',
        dob: dob,
        age_estimate: age_estimate,
        gender: 'female',
        relationships: relationships,
      )
    }

    let(:dob) { Date.new(2018, 1, 20) }
    let(:age_estimate) { nil }
    let(:relationships) { double('relationships') }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:other_children_details)
      end
    end

    describe '#answers' do
      before do
        allow(relationships).to receive_message_chain(:where, :pluck).and_return(['mother'])
      end

      it 'has the correct number of rows' do
        expect(answers.count).to eq(6)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(Separator)
        expect(answers[0].title).to eq(:child_index_title)
        expect(answers[0].i18n_opts).to eq({index: 1})

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:child_full_name)
        expect(answers[1].value).to eq('name')

        expect(answers[2]).to be_an_instance_of(DateAnswer)
        expect(answers[2].question).to eq(:child_dob)
        expect(answers[2].value).to eq(Date.new(2018, 1, 20))

        expect(answers[3]).to be_an_instance_of(Answer)
        expect(answers[3].question).to eq(:child_sex)
        expect(answers[3].value).to eq('female')

        expect(answers[4]).to be_an_instance_of(MultiAnswer)
        expect(answers[4].question).to eq(:child_applicants_relationship)
        expect(answers[4].value).to eq(['mother'])
        expect(c100_application).to have_received(:applicants)

        expect(answers[5]).to be_an_instance_of(MultiAnswer)
        expect(answers[5].question).to eq(:child_respondents_relationship)
        expect(answers[5].value).to eq(['mother'])
        expect(c100_application).to have_received(:respondents)
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