require 'spec_helper'

module Summary
  describe Sections::AdditionalInformation do
    let(:c100_application) { double(C100Application).as_null_object }
    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:additional_information)
      end
    end

    describe '#answers' do
      it 'has the correct number of rows' do
        expect(answers.count).to eq(6)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:asking_for_permission)
        expect(answers[0].value).to eq(GenericYesNo::NO) # Always NO

        expect(answers[1]).to be_an_instance_of(Answer)
        expect(answers[1].question).to eq(:urgent_or_without_notice)
        expect(answers[1].value).to eq(GenericYesNo::NO) # The values of this are tested separated

        expect(answers[2]).to be_an_instance_of(Answer)
        expect(answers[2].question).to eq(:children_previous_proceedings)
        expect(c100_application).to have_received(:children_previous_proceedings)

        expect(answers[3]).to be_an_instance_of(Answer)
        expect(answers[3].question).to eq(:consent_order)
        expect(c100_application).to have_received(:consent_order)

        expect(answers[4]).to be_an_instance_of(Answer)
        expect(answers[4].question).to eq(:international_or_capacity)
        expect(answers[4].value).to eq(GenericYesNo::NO) # The values of this are tested separated

        expect(answers[5]).to be_an_instance_of(Answer)
        expect(answers[5].question).to eq(:language_assistance)
        expect(c100_application).to have_received(:language_help)
      end
    end

    describe '`urgent_or_without_notice_value` answer values' do
      before do
        expect(c100_application).to receive(:urgent_hearing).and_return(urgent_hearing)
        expect(c100_application).to receive(:without_notice)
      end

      context 'at least one question was answered as `YES`' do
        let(:urgent_hearing) { 'yes' }

        it 'returns the question value' do
          expect(answers[1].value).to eq('yes')
        end
      end

      context 'there are no questions answered with `YES`' do
        let(:urgent_hearing) { 'no' }

        it 'returns the default value for the answer' do
          expect(answers[1].value).to eq(GenericYesNo::NO)
        end
      end
    end

    describe '`international_or_capacity` answer values' do
      before do
        expect(c100_application).to receive(:international_resident).and_return(international_resident)
        expect(c100_application).to receive(:international_jurisdiction)
        expect(c100_application).to receive(:international_request)
        expect(c100_application).to receive(:reduced_litigation_capacity)
      end

      context 'at least one question was answered as `YES`' do
        let(:international_resident) { 'yes' }

        it 'returns the question value' do
          expect(answers[4].value).to eq('yes')
        end
      end

      context 'there are no questions answered with `YES`' do
        let(:international_resident) { 'no' }

        it 'returns the default value for the answer' do
          expect(answers[4].value).to eq(GenericYesNo::NO)
        end
      end
    end
  end
end
