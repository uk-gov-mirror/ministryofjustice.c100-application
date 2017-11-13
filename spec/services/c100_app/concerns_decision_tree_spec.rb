require 'rails_helper'

RSpec.describe C100App::ConcernsDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      {
    {
      'subject': abuse_subject,
      'kind': abuse_kind,
      'answer': abuse_answer
    }
  }
  let(:next_step)        { nil }
  let(:as)               { nil }

  let(:abuse_subject)    { 'applicant' }
  let(:abuse_kind)       { 'substances' }
  let(:abuse_answer)     { 'no' }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  # Mutant killers
  it 'retrieve the subject from the `step_params`' do
    expect(subject.step_params).to receive(:[]).with(:subject).and_return(:applicant)
    expect(subject).to receive(:applicant_questions_destination)
    subject.destination
  end

  it 'retrieve the abuse kind from the `step_params`' do
    expect(subject.step_params).to receive(:[]).with(:kind).and_return(:other)
    expect(subject).to receive(:abuse_subject).and_return(AbuseSubject::APPLICANT)
    subject.destination
  end

  describe 'when answer is `no`' do
    let(:abuse_answer) { 'no' }

    context 'when the subject is invalid' do
      let(:abuse_subject) { 'foobar' }

      it 'raises an error' do
        expect { subject.destination }.to raise_error(
          BaseDecisionTree::InvalidStep, "Invalid step '{:subject=>\"foobar\", :kind=>\"substances\", :answer=>\"no\"}'"
        )
      end
    end

    context 'when the subject is `applicant`' do
      let(:abuse_subject) { 'applicant' }

      context 'when the abuse kind is invalid' do
        let(:abuse_kind) { 'foobar' }

        it 'raises an error' do
          expect { subject.destination }.to raise_error(
            BaseDecisionTree::InvalidStep, 'Unknown abuse kind: foobar'
          )
        end
      end

      context 'abuse kind `substances`' do
        let(:abuse_kind) { 'substances' }
        it {is_expected.to have_destination(:abuse_question, :edit, {subject: 'applicant', kind: 'physical'})}
      end

      context 'abuse kind `physical`' do
        let(:abuse_kind) { 'physical' }
        it {is_expected.to have_destination(:abuse_question, :edit, {subject: 'applicant', kind: 'emotional'})}
      end

      context 'abuse kind `emotional`' do
        let(:abuse_kind) { 'emotional' }
        it {is_expected.to have_destination(:abuse_question, :edit, {subject: 'applicant', kind: 'psychological'})}
      end

      context 'abuse kind `psychological`' do
        let(:abuse_kind) { 'psychological' }
        it {is_expected.to have_destination(:abuse_question, :edit, {subject: 'applicant', kind: 'sexual'})}
      end

      context 'abuse kind `sexual`' do
        let(:abuse_kind) { 'sexual' }
        it {is_expected.to have_destination(:abuse_question, :edit, {subject: 'applicant', kind: 'financial'})}
      end

      context 'abuse kind `financial`' do
        let(:abuse_kind) { 'financial' }
        it {is_expected.to have_destination(:abuse_question, :edit, {subject: 'applicant', kind: 'other'})}
      end

      context 'abuse kind `other`' do
        let(:abuse_kind) { 'other' }
        it {is_expected.to have_destination(:abuse_question, :edit, {subject: 'children', kind: 'physical'})}
      end
    end

    context 'when the subject is `children`' do
      let(:abuse_subject) { 'children' }

      context 'abuse kind `physical`' do
        let(:abuse_kind) { 'physical' }
        it {is_expected.to have_destination(:abuse_question, :edit, {subject: 'children', kind: 'emotional'})}
      end

      context 'abuse kind `emotional`' do
        let(:abuse_kind) { 'emotional' }
        it {is_expected.to have_destination(:abuse_question, :edit, {subject: 'children', kind: 'psychological'})}
      end

      context 'abuse kind `psychological`' do
        let(:abuse_kind) { 'psychological' }
        it {is_expected.to have_destination(:abuse_question, :edit, {subject: 'children', kind: 'sexual'})}
      end

      context 'abuse kind `sexual`' do
        let(:abuse_kind) { 'sexual' }
        it {is_expected.to have_destination(:abuse_question, :edit, {subject: 'children', kind: 'financial'})}
      end

      context 'abuse kind `financial`' do
        let(:abuse_kind) { 'financial' }
        it {is_expected.to have_destination(:abuse_question, :edit, {subject: 'children', kind: 'other'})}
      end

      context 'abuse kind `other`' do
        let(:abuse_kind) { 'other' }
        it {is_expected.to have_destination('/steps/children/instructions', :show)}
      end
    end
  end
end
