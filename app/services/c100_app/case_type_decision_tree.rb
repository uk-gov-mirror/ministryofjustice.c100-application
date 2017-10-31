module C100App
  class CaseTypeDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :case_type
        after_case_type_step
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_case_type_step
      show(:case_type_kickout)
    end
  end
end
