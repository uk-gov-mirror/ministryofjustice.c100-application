module Steps
  module SafetyQuestions
    class SubstanceAbuseForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :substance_abuse
    end
  end
end
