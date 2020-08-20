require 'spec_helper'

module Summary
  describe HtmlSections::ApplicationReasons do
    let(:c100_application) {
      instance_double(C100Application,
        application_details: 'details',
              permission_sought: 'yes',
              permission_details: 'details',
    ) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:application_reasons) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(3)

        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:permission_sought)
        expect(c100_application).to have_received(:permission_sought)
        expect(answers[0].change_path).to eq('/steps/application/permission_sought')

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:permission_details)
        expect(c100_application).to have_received(:permission_details)
        expect(answers[1].change_path).to eq('/steps/application/permission_details')

        expect(answers[2]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[2].question).to eq(:application_details)
        expect(c100_application).to have_received(:application_details)
        expect(answers[2].change_path).to eq('/steps/application/details')
      end
    end
  end
end
