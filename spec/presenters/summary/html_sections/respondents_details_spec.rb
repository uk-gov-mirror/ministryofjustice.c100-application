require 'spec_helper'

module Summary
  describe HtmlSections::RespondentsDetails do
    let(:c100_application) {
      instance_double(
        C100Application,
        respondents: [respondent]
      )
    }

    let(:respondent) {
      instance_double(Respondent,
        to_param: 'uuid-123',
        full_name: 'fullname',
        has_previous_name: has_previous_name,
        previous_name: previous_name,
        dob: Date.new(2018, 1, 20),
        age_estimate: nil,
        gender: 'female',
        birthplace: 'birthplace',
        address: 'address',
        residence_requirement_met: 'yes',
        residence_history: 'history',
        home_phone: 'home_phone',
        mobile_phone: 'mobile_phone',
        email: 'email',
      )
    }

    subject { described_class.new(c100_application) }

    let(:has_previous_name) { 'no' }
    let(:previous_name) { nil }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:respondents_details) }
    end

    describe '#record_collection' do
      it {
        expect(c100_application).to receive(:respondents)
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
        expect(answers.count).to eq(4)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(Separator)
        expect(answers[0].title).to eq('respondents_details_index_title')
        expect(answers[0].i18n_opts).to eq({index: 1})

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:person_full_name)
        expect(answers[1].change_path).to eq('/steps/respondent/names/')
        expect(answers[1].value).to eq('fullname')

        expect(answers[2]).to be_an_instance_of(AnswersGroup)
        expect(answers[2].name).to eq(:person_personal_details)
        expect(answers[2].change_path).to eq('/steps/respondent/personal_details/uuid-123')
        expect(answers[2].answers.count).to eq(4)

          # personal_details group answers ###
          details = answers[2].answers

          expect(details[0]).to be_an_instance_of(Answer)
          expect(details[0].question).to eq(:person_previous_name)
          expect(details[0].value).to eq('no')

          expect(details[1]).to be_an_instance_of(Answer)
          expect(details[1].question).to eq(:person_sex)
          expect(details[1].value).to eq('female')

          expect(details[2]).to be_an_instance_of(DateAnswer)
          expect(details[2].question).to eq(:person_dob)
          expect(details[2].value).to eq(Date.new(2018, 1, 20))

          expect(details[3]).to be_an_instance_of(FreeTextAnswer)
          expect(details[3].question).to eq(:person_birthplace)
          expect(details[3].value).to eq('birthplace')

        expect(answers[3]).to be_an_instance_of(AnswersGroup)
        expect(answers[3].name).to eq(:person_contact_details)
        expect(answers[3].change_path).to eq('/steps/respondent/contact_details/uuid-123')
        expect(answers[3].answers.count).to eq(6)

          # personal_details group answers ###
          details = answers[3].answers

          expect(details[0]).to be_an_instance_of(FreeTextAnswer)
          expect(details[0].question).to eq(:person_address)
          expect(details[0].value).to eq('address')

          expect(details[1]).to be_an_instance_of(Answer)
          expect(details[1].question).to eq(:person_residence_requirement_met)
          expect(details[1].value).to eq('yes')

          expect(details[2]).to be_an_instance_of(FreeTextAnswer)
          expect(details[2].question).to eq(:person_residence_history)
          expect(details[2].value).to eq('history')

          expect(details[3]).to be_an_instance_of(FreeTextAnswer)
          expect(details[3].question).to eq(:person_home_phone)
          expect(details[3].value).to eq('home_phone')

          expect(details[4]).to be_an_instance_of(FreeTextAnswer)
          expect(details[4].question).to eq(:person_mobile_phone)
          expect(details[4].value).to eq('mobile_phone')

          expect(details[5]).to be_an_instance_of(FreeTextAnswer)
          expect(details[5].question).to eq(:person_email)
          expect(details[5].value).to eq('email')
      end

      context 'for existing previous name' do
        let(:has_previous_name) { 'yes' }
        let(:previous_name) { 'previous_name' }

        it 'has the correct number of rows' do
          expect(answers.count).to eq(4)
        end

        it 'renders the previous name' do
          expect(answers[2]).to be_an_instance_of(AnswersGroup)

          details = answers[2].answers
          expect(details[0]).to be_an_instance_of(FreeTextAnswer)
          expect(details[0].question).to eq(:person_previous_name)
          expect(details[0].value).to eq('previous_name')
        end
      end
    end
  end
end
