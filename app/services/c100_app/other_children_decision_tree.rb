module C100App
  class OtherChildrenDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :add_another_name
        edit(:names)
      when :names_finished
        after_names_finished
      when :personal_details
        after_personal_details
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
        edit('/steps/applicant/names')
      end
    end

    def next_child
      @_next_child ||= begin
        ids = c100_application.other_child_ids

        return ids.first if record.nil?

        pos = ids.index(record.id)
        ids.at(pos + 1)
      end
    end
  end
end
