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

  def other_issue?
    orders.include?(PetitionOrder::OTHER_ISSUE.to_s)
  end

  def other_issue_details
    orders_additional_details
  end

  private

  def selected_orders_from(collection)
    filtered(collection.map(&:to_s)) & orders
  end

  # We filter out `group_xxx` items, as the purpose of these are to present the orders
  # in groups for the user to show/hide them, and are not really an order by itself.
  #
  def filtered(collection)
    collection.grep_v(/^group_/)
  end
end
