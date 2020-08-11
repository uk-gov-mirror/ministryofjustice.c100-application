module Steps
  module Permission
    class ConsentForm < QuestionForm
      include SingleQuestionForm

      yes_no_attribute :consent,
                       reset_when_yes: [
                         # To be added once we have next questions
                       ]
    end
  end
end
