module C100App
  class RespondentDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :personal_details, :add_another_respondent
        edit(:personal_details)
      when :respondents_finished
        show('/steps/children/instructions')
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
  end
end
