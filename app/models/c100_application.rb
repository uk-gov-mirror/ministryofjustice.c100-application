class C100Application < ApplicationRecord
  belongs_to :user, optional: true, dependent: :destroy

  has_one  :abduction_detail, dependent: :destroy
  has_one  :asking_order,     dependent: :destroy
  has_one  :court_order,      dependent: :destroy

  has_many :abuse_concerns,   dependent: :destroy
  has_many :relationships,    dependent: :destroy

  # Remember, we are using UUIDs as the record IDs, we can't rely on ID sequential ordering
  has_many :children,    -> { order(created_at: :asc) }, dependent: :destroy
  has_many :applicants,  -> { order(created_at: :asc) }, dependent: :destroy
  has_many :respondents, -> { order(created_at: :asc) }, dependent: :destroy

  has_many :other_children, -> { order(created_at: :asc) }, dependent: :destroy
  has_many :other_parties,  -> { order(created_at: :asc) }, dependent: :destroy

  has_value_object :user_type
  has_value_object :help_paying
  has_value_object :concerns_contact_type
  has_value_object :concerns_contact_other,        class_name: 'GenericYesNo'
  has_value_object :children_previous_proceedings, class_name: 'GenericYesNo'
  has_value_object :emergency_proceedings,         class_name: 'GenericYesNo'
end
