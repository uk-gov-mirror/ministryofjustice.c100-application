module Steps
  module Permission
    class ConsentForm < QuestionForm
      yes_no_attribute :consent,
                       reset_when_yes: [
                         :family,
                       ]
    end
  end
end
