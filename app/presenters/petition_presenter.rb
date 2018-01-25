class PetitionPresenter < SimpleDelegator
  def child_arrangements_orders
    selected_orders_from(PetitionOrder::CHILD_ARRANGEMENTS)
  end

  def specific_issues_orders
    selected_orders_from(PetitionOrder::SPECIFIC_ISSUES)
  end

  def prohibited_steps_orders
    selected_orders_from(PetitionOrder::PROHIBITED_STEPS)
  end

  def all_selected_orders
    selected_orders_from(PetitionOrder.values)
  end

  def other_details
    __getobj__&.other_details
  end

  private

  def selected_orders_from(collection)
    return [] if __getobj__.nil?
    collection.select { |attrib| self[attrib] }
  end
end
