module Steps
  module Permission
    class LivingOrderForm < QuestionForm
      include SingleQuestionForm

      yes_no_attribute :living_order,
                       reset_when_yes: [
                         # To be added once we have next questions
                       ]
    end
  end
end
