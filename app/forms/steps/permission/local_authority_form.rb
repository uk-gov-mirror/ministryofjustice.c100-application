module Steps
  module Permission
    class LocalAuthorityForm < QuestionForm
      include SingleQuestionForm

      yes_no_attribute :local_authority,
                       reset_when_yes: [
                         :relative,
                       ]
    end
  end
end
