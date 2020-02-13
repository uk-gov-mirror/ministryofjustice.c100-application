module C100App
  class AttendingCourtDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :language
        edit(:intermediary)
      when :intermediary
        edit(:special_arrangements)
      when :special_arrangements
        edit('/steps/application/special_assistance')
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
  end
end
