class PetitionPresenter < SimpleDelegator
  ORDERS = {
    child_arrangements: [
      :child_home,
      :child_times,
      :child_contact
    ],
    specific_issues: [
      :child_specific_issue_school,
      :child_specific_issue_religion,
      :child_specific_issue_name,
      :child_specific_issue_medical,
      :child_specific_issue_abroad,
      :child_return
    ],
    prohibited_steps: [
      :child_abduction,
      :child_flight
    ]
  }.freeze

  def child_arrangements_orders
    orders_for(:child_arrangements)
  end

  def specific_issues_orders
    orders_for(:specific_issues)
  end

  def prohibited_steps_orders
    orders_for(:prohibited_steps)
  end

  private

  def orders_for(group_name)
    ORDERS.fetch(group_name).select { |attrib| self[attrib] }
  end
end
