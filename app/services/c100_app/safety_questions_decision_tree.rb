module C100App
  class SafetyQuestionsDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :risk_of_abduction
        edit(:substance_abuse)
      when :substance_abuse
        after_substance_abuse
      when :substance_abuse_details
        edit('/steps/abuse_concerns/question') # TODO: change when we have next step
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_substance_abuse
      if question(:substance_abuse).yes?
        edit(:substance_abuse_details)
      else
        edit('/steps/abuse_concerns/question') # TODO: change when we have next step
      end
    end
  end
end
