class CaseTypeDecisionTree < BaseDecisionTree
  def destination
    return next_step if next_step

    case step_name.to_sym
    when :case_type
      after_case_type_step
    else
      raise InvalidStep, "Invalid step '#{step_params}'"
    end
  end

  private

  def after_case_type_step
    show(:case_type_kickout)
  end
end
