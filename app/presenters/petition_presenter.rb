class PetitionPresenter < SimpleDelegator
  def child_arrangements_orders
    selected_orders_from(OrderAttributes::CHILD_ARRANGEMENTS)
  end

  def specific_issues_orders
    selected_orders_from(OrderAttributes::SPECIFIC_ISSUES)
  end

  def prohibited_steps_orders
    selected_orders_from(OrderAttributes::PROHIBITED_STEPS)
  end

  def all_selected_orders
    selected_orders_from(OrderAttributes::ALL_ORDERS)
  end

  private

  def selected_orders_from(collection)
    return [] if __getobj__.nil?
    collection.select { |attrib| self[attrib] }
  end
end
