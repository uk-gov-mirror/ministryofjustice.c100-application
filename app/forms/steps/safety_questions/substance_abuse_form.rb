module Steps
  module SafetyQuestions
    class SubstanceAbuseForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :substance_abuse, reset_when_no: [:substance_abuse_details]
    end
  end
end
