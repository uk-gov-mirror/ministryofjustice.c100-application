module C100App
  class ChildrenDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :add_another_name
        edit(:names)
      when :names_finished, :personal_details, :add_another_child
        edit(:personal_details)
      when :children_finished
        edit(:additional_details)
      when :additional_details
        edit('/steps/applicant/personal_details')
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
  end
end
