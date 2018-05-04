require 'spec_helper'

module Summary
  describe HtmlSections::OtherPartiesDetails do
    let(:c100_application) {
      instance_double(
        C100Application,
        has_other_parties: 'yes',
        other_parties: [other_party]
      )
    }

    let(:other_party) {
      instance_double(OtherParty,
        to_param: 'uuid-123',
        full_name: 'fullname',
        has_previous_name: 'no',
        previous_name: nil,
        dob: Date.new(2018, 1, 20),
        age_estimate: nil,
        gender: 'female',
        birthplace: nil,
        address: 'address',
        residence_requirement_met: nil,
        residence_history: nil,
        home_phone: nil,
        mobile_phone: nil,
        email: nil,
      )
    }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:other_parties_details) }
    end

    describe '#record_collection' do
      it {
        expect(c100_application).to receive(:other_parties)
        subject.record_collection
      }
    end

    # The following tests can be fragile, but on purpose. During the development phase
    # we have to update the tests each time we introduce a new row or remove another.
    # But once it is finished and stable, it will raise a red flag if it ever gets out
    # of sync, which means a quite solid safety net for any maintainers in the future.
    #
    describe '#answers' do
      it 'has the correct number of rows' do
        expect(answers.count).to eq(5)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:has_other_parties)
        expect(answers[0].change_path).to eq('/steps/respondent/has_other_parties')
        expect(answers[0].value).to eq('yes')

        expect(answers[1]).to be_an_instance_of(Separator)
        expect(answers[1].title).to eq('other_parties_details_index_title')
        expect(answers[1].i18n_opts).to eq({index: 1})

        expect(answers[2]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[2].question).to eq(:person_full_name)
        expect(answers[2].change_path).to eq('/steps/other_parties/names/')
        expect(answers[2].value).to eq('fullname')

        expect(answers[3]).to be_an_instance_of(AnswersGroup)
        expect(answers[3].name).to eq(:person_personal_details)
        expect(answers[3].change_path).to eq('/steps/other_parties/personal_details/uuid-123')
        expect(answers[3].answers.count).to eq(3)

          # personal_details group answers ###
          details = answers[3].answers

          expect(details[0]).to be_an_instance_of(Answer)
          expect(details[0].question).to eq(:person_previous_name)
          expect(details[0].value).to eq('no')

          expect(details[1]).to be_an_instance_of(Answer)
          expect(details[1].question).to eq(:person_sex)
          expect(details[1].value).to eq('female')

          expect(details[2]).to be_an_instance_of(DateAnswer)
          expect(details[2].question).to eq(:person_dob)
          expect(details[2].value).to eq(Date.new(2018, 1, 20))

        expect(answers[4]).to be_an_instance_of(AnswersGroup)
        expect(answers[4].name).to eq(:person_contact_details)
        expect(answers[4].change_path).to eq('/steps/other_parties/contact_details/uuid-123')
        expect(answers[4].answers.count).to eq(1)

          # personal_details group answers ###
          details = answers[4].answers

          expect(details[0]).to be_an_instance_of(FreeTextAnswer)
          expect(details[0].question).to eq(:person_address)
          expect(details[0].value).to eq('address')
      end

      context 'when there are no other parties' do
        let(:c100_application) {
          instance_double(
            C100Application,
            has_other_parties: 'no',
            other_parties: []
          )
        }

        it 'has the correct number of rows' do
          expect(answers.count).to eq(1)

          expect(answers[0]).to be_an_instance_of(Answer)
          expect(answers[0].question).to eq(:has_other_parties)
          expect(answers[0].change_path).to eq('/steps/respondent/has_other_parties')
          expect(answers[0].value).to eq('no')
        end
      end
    end
  end
end
