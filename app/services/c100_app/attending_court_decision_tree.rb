module C100App
  class AttendingCourtDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :language
        edit('/steps/application/intermediary')
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
  end
end
