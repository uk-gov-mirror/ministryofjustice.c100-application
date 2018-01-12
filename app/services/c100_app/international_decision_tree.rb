module C100App
  class InternationalDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :resident
        edit(:jurisdiction)
      when :jurisdiction
        edit(:request)
      when :request
        edit(:resident) # TODO: update when we have the next block of steps
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
  end
end
