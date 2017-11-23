module C100App
  class MiamDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :miam_acknowledgement
        edit(:attended)
      when :miam_attended
        edit('/steps/applicant/number_of_children') # TODO: change when we have next step
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
  end
end
