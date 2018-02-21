require 'spec_helper'

module Summary
  describe Sections::StatementOfTruth do
    let(:c100_application) { instance_double(C100Application, applicants: applicants) }
    let(:applicants) { [instance_double(Applicant, full_name: 'John Doe')] }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:statement_of_truth) }
    end

    describe '#show_header?' do
      it { expect(subject.show_header?).to eq(false) }
    end

    describe '#answers' do
      it 'has the correct number of rows' do
        expect(answers.count).to eq(1)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(Partial)
        expect(answers[0].name).to eq(:statement_of_truth)
      end

      it 'propagates to the Partial the name of the first applicant as an ivar' do
        expect(applicants).to receive(:first).and_call_original
        expect(answers[0].ivar).to eq('John Doe')
      end
    end
  end
end
