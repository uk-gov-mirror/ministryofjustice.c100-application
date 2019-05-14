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
    edit(:relationship, id: record, child_id: first_minor_id)
  end

  def children_relationships
    if next_child_id
      edit(:relationship, id: record.person, child_id: next_child_id)
    else
      return edit('/steps/address/lookup', id: record.person) if address_lookup_enabled?
      edit(:address_details, id: record.person)
    end
  end

  def edit_contact_details
    edit(:contact_details, id: record)
  end

  def next_child_id
    next_record_id(c100_application.minor_ids, current: record.minor)
  end

  # Minors collection include `Child` and `OtherChild` types.
  def first_minor_id
    c100_application.minor_ids.first
  end

  # Children collection only include `Child` type. This should be used in
  # the residence loop, as we only need the residence of the main children.
  def first_child_id
    c100_application.child_ids.first
  end

  # TODO: temporary feature-flag for the address lookup. Do not enable yet on staging
  # as this is still under heavy WIP.
  # Also note, the version needs to be at least 3, which contains the split address work.
  #
  def address_lookup_enabled?
    c100_application.version > 2 && ENV.key?('ADDRESS_LOOKUP_ENABLED')
  end
end
