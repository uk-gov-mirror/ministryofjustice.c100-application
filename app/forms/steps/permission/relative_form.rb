module Steps
  module Permission
    class RelativeForm < QuestionForm
      include SingleQuestionForm

      yes_no_attribute :relative
    end
  end
end
