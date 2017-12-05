module C100App
  class PetitionDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :orders
        after_orders
      when :other_issue
        start_children_journey
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_orders
      if checked?(:other)
        edit(:other_issue)
      else
        start_children_journey
      end
    end

    def start_children_journey
      edit('/steps/children/names')
    end
  end
end
