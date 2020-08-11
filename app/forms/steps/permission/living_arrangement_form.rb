module Steps
  module Permission
    class LivingArrangementForm < QuestionForm
      include SingleQuestionForm

      yes_no_attribute :living_arrangement,
                       reset_when_yes: [
                         # To be added once we have next questions
                       ]
    end
  end
end
