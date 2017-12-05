module C100App
  class ChildrenDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :add_another_name
        edit(:names)
      when :names_finished
        after_names_finished
      when :personal_details
        after_personal_details
      when :additional_details
        edit(:other_children)
      when :other_children
        after_other_children
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_names_finished
      edit(:personal_details, id: next_child)
    end

    def after_personal_details
      if next_child
        edit(:personal_details, id: next_child)
      else
        edit(:additional_details)
      end
    end

    def after_other_children
      if question(:other_children).yes?
        edit('/steps/other_children/names')
      else
        edit('/steps/applicant/personal_details')
      end
    end

    def next_child
      @_next_child ||= begin
        ids = c100_application.children.primary.pluck(:id)

        return ids.first if record.nil?

        pos = ids.index(record.id)
        ids.at(pos + 1)
      end
    end
  end
end
