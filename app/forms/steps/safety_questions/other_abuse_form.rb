module Steps
  module SafetyQuestions
    class OtherAbuseForm < BaseForm
      include SingleQuestionForm

      # The applicant can only reach this step if all previous safety questions
      # were answered `no`. If they also answer `no` to this one, then we delete
      # any abuse concerns details, as C1A does not apply anymore.

      # The reset will delete any associated rows from the `abuse_concerns` table.
      # Because this is a `has_many` association, we nil their IDs to delete the rows.
      yes_no_attribute :other_abuse, reset_when_no: [:abuse_concern_ids]
    end
  end
end
