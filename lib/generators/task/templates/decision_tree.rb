module C100App
  class <%= task_name.camelize %>DecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name.to_sym
        # TODO: Put decision logic here
      else
        raise InvalidStep, "Invalid step '#{step_params}'"
      end
    end
  end
end
