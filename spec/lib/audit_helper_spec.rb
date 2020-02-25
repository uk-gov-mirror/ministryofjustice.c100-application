require 'rails_helper'

describe AuditHelper do
  let(:c100_application) {
    C100Application.new(
      version: 123,
      has_solicitor: 'yes',
      reduced_litigation_capacity: 'yes',
      urgent_hearing: 'no',
      without_notice: 'yes',
      payment_type: 'cash',
      declaration_signee_capacity: 'applicant',
    )
  }

  let(:user_id) { nil }
  let(:screener_answers_court) { instance_double(Court, name: 'Test Court') }
  let(:screener_answers) { instance_double(ScreenerAnswers, children_postcodes: 'abcd 123') }

  let(:court_arrangement) { nil }

  subject { described_class.new(c100_application) }

  before do
    allow(c100_application).to receive(:user_id).and_return(user_id)
    allow(c100_application).to receive(:screener_answers).and_return(screener_answers)
    allow(c100_application).to receive(:screener_answers_court).and_return(screener_answers_court)
    allow(c100_application).to receive(:court_arrangement).and_return(court_arrangement)
  end

  describe '#metadata' do
    it 'returns the expected information' do
      expect(
        subject.metadata
      ).to eq(
        v: 123,
        postcode: 'ABCD1**',
        c1a_form: false,
        c8_form: false,
        saved_for_later: false,
        legal_representation: 'yes',
        urgent_hearing: 'no',
        without_notice: 'yes',
        reduced_litigation: 'yes',
        payment_type: 'cash',
        signee_capacity: 'applicant',
        arrangements: [],
      )
    end

    # TODO we can cleanup this when all applications are using the new table
    context 'when we have court arrangements' do
      let(:court_arrangement) {
        CourtArrangement.new(
          intermediary_help: 'yes',
          language_options: %w(language_interpreter),
          special_arrangements: %w(video_link protective_screens),
          special_assistance: %w(hearing_loop),
        )
      }

      it 'returns the expected information' do
        expect(
          subject.metadata[:arrangements]
        ).to match_array(%w(
          intermediary
          language_interpreter
          video_link
          protective_screens
          hearing_loop
        ))
      end
    end

    context 'for a saved application' do
      let(:user_id) { 123 }

      it 'returns the expected information' do
        expect(
          subject.metadata
        ).to include(saved_for_later: true)
      end
    end
  end
end
