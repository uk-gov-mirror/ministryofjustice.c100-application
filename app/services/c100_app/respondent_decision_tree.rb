module C100App
  class RespondentDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :number_of_children, :add_another_respondent
        edit(:personal_details)
      when :respondents_finished
        root_path # TODO: update when we have next step
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
  end
end
