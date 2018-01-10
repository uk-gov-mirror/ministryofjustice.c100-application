module C100App
  class ChildrenDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :add_another_name
        edit(:names)
      when :names_finished
        edit(:personal_details, id: next_child_id)
      when :personal_details
        edit(:orders, id: record) # TODO: refinement to bypass `orders` when children < 2
      when :orders
        after_orders
      when :additional_details
        edit(:has_other_children)
      when :has_other_children
        after_has_other_children
      when :residence
        after_child_residence
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_has_other_children
      if question(:has_other_children).yes?
        edit('/steps/other_children/names')
      else
        edit('/steps/applicant/names')
      end
    end

    def after_orders
      if next_child_id
        edit(:personal_details, id: next_child_id)
      else
        edit(:additional_details)
      end
    end

    def after_child_residence
      # Here `record` is not a Child but instead a ChildResidence instance, so we
      # need to pass an explicit `current` argument with the associated Child record.
      child_id = next_child_id(current: record.child)

      if child_id
        edit(:residence, id: child_id)
      else
        edit('/steps/abuse_concerns/previous_proceedings')
      end
    end

    def next_child_id(current: record)
      next_record_id(c100_application.child_ids, current: current)
    end
  end
end
