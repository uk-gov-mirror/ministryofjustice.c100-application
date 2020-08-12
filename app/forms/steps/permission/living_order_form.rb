module Steps
  module Permission
    class LivingOrderForm < QuestionForm
      yes_no_attribute :living_order,
                       reset_when_yes: [
                         :amendment,
                       ]
    end
  end
end
