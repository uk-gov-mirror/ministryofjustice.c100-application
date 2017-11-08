module C100App
  class ChildrenDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :number_of_children, :add_another_child
        edit(:personal_details)
      when :children_finished
        edit(:additional_details)
      when :additional_details
        root_path # TODO: update when we have next step
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
  end
end
