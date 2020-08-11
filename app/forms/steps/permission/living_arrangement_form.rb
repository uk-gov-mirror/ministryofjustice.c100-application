module Steps
  module Permission
    class LivingArrangementForm < QuestionForm
      include SingleQuestionForm

      yes_no_attribute :living_arrangement,
                       reset_when_yes: [
                         :consent
                       ]
    end
  end
end
