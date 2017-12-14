module OrderAttributes
  include Virtus.model

  CHILD_ARRANGEMENTS = [
    :child_home,
    :child_times,
    :child_contact
  ].freeze

  SPECIFIC_ISSUES = [
    :child_specific_issue_school,
    :child_specific_issue_religion,
    :child_specific_issue_name,
    :child_specific_issue_medical,
    :child_specific_issue_abroad,
    :child_return
  ].freeze

  PROHIBITED_STEPS = [
    :child_abduction,
    :child_flight
  ].freeze

  OTHER = [
    :other
  ].freeze

  ALL_ORDERS = [CHILD_ARRANGEMENTS, SPECIFIC_ISSUES, PROHIBITED_STEPS, OTHER].flatten.freeze

  def self.included(form)
    ALL_ORDERS.each { |name| form.attribute(name, Boolean) }
  end
end
