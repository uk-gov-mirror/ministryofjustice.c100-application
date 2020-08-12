module Steps
  module Permission
    class ParentalResponsibilityForm < QuestionForm
      yes_no_attribute :parental_responsibility,
                       reset_when_yes: [
                         :living_order,
                       ]
    end
  end
end
