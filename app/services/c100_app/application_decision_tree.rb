module C100App
  class ApplicationDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :without_notice
        edit(:without_notice) # TODO: change when we have next step
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
  end
end
