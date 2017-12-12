module C100App
  class PetitionDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :orders
        after_orders
      when :other_issue
        start_alternatives_journey
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_orders
      if checked?(:other)
        edit(:other_issue)
      else
        start_alternatives_journey
      end
    end

    def start_alternatives_journey
      edit('/steps/alternatives/court')
    end
  end
end
