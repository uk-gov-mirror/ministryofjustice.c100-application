module Steps
  module Permission
    class TimeOrderForm < QuestionForm
      yes_no_attribute :time_order,
                       reset_when_yes: [
                         :living_arrangement,
                       ]
    end
  end
end
