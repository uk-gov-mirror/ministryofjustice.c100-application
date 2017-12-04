module C100App
  class OtherChildrenDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :add_another_name
        edit(:names)
      when :names_finished
        edit('/steps/applicant/personal_details') # TODO: change when we have more steps
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
  end
end
