module C100App
  class ChildrenDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :add_another_name
        edit(:names)
      when :names_finished
        edit(:personal_details, id: next_record_id)
      when :personal_details
        after_personal_details
      when :additional_details
        edit(:has_other_children)
      when :has_other_children
        after_has_other_children
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_personal_details
      if next_record_id
        edit(:personal_details, id: next_record_id)
      else
        edit(:additional_details)
      end
    end

    def after_has_other_children
      if question(:has_other_children).yes?
        edit('/steps/other_children/names')
      else
        edit('/steps/applicant/names')
      end
    end

    def next_record_id
      super(c100_application.child_ids)
    end
  end
end
