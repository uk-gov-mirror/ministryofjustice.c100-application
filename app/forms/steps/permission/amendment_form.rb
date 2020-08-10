module Steps
  module Permission
    class AmendmentForm < QuestionForm
      include SingleQuestionForm

      yes_no_attribute :amendment,
                       reset_when_yes: [
                         # To be added once we have next questions
                       ]
    end
  end
end
