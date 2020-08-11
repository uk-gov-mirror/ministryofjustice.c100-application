module Steps
  module Permission
    class FamilyForm < QuestionForm
      include SingleQuestionForm

      yes_no_attribute :family,
                       reset_when_yes: [
                         # To be added once we have next questions
                       ]
    end
  end
end
