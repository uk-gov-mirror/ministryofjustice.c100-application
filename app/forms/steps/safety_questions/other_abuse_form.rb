module Steps
  module SafetyQuestions
    class OtherAbuseForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :other_abuse
    end
  end
end
