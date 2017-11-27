module C100App
  class AbductionDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :children_have_passport
        edit('/steps/safety_questions/substance_abuse') # TODO: change when we have next step
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
  end
end
