module Steps
  module Permission
    class TimeOrderForm < QuestionForm
      include SingleQuestionForm

      yes_no_attribute :time_order,
                       reset_when_yes: [
                         # To be added once we have next questions
                       ]
    end
  end
end
