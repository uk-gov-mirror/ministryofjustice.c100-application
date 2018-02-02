class PeopleDecisionTree < BaseDecisionTree
  private

  def after_personal_details(age_check: true)
    if age_check && dob_under_age?
      edit(:under_age, id: record)
    else
      edit_first_child_relationships
    end
  end

  def dob_under_age?
    record.reload.dob > 18.years.ago
  end

  def edit_first_child_relationships
    edit(:relationship, id: record, child_id: first_child_id)
  end

  def children_relationships
    if next_child_id
      edit(:relationship, id: record.person, child_id: next_child_id)
    else
      edit(:contact_details, id: record.person)
    end
  end

  def next_child_id
    next_record_id(c100_application.child_ids, current: record.child)
  end

  def first_child_id
    c100_application.child_ids.first
  end
end
