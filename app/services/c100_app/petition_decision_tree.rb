module C100App
  class PetitionDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :orders
        after_orders
      when :other_issue
        show('/steps/safety_questions/start') # TODO: change when we have next step
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_orders
      if checked?(:other)
        edit(:other_issue)
      else
        show('/steps/safety_questions/start') # TODO: change when we have next step
      end
    end
  end
end
