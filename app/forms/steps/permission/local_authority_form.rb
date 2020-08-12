module Steps
  module Permission
    class LocalAuthorityForm < QuestionForm
      include SingleQuestionForm

      yes_no_attribute :local_authority,
                       reset_when_yes: [
                         # To be added once we have next questions
                       ]
    end
  end
end
