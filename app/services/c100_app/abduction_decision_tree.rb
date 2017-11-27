module C100App
  class AbductionDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :children_have_passport
        after_children_have_passport
      when :international
        edit('/steps/safety_questions/substance_abuse') # TODO: change when we have next step
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_children_have_passport
      if selected?(:children_have_passport)
        edit(:international)
      else
        edit('/steps/safety_questions/substance_abuse') # TODO: change when we have next step
      end
    end
  end
end
