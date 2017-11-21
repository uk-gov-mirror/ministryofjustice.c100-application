module C100App
  class SafetyQuestionsDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :risk_of_abduction
        edit('/steps/abuse_concerns/question') # TODO: change when we have next step
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
  end
end
