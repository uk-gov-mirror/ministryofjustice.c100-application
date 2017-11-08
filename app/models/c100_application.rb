class C100Application < ApplicationRecord
  belongs_to :user, optional: true, dependent: :destroy

  has_many :children,    dependent: :destroy
  has_many :applicants,  dependent: :destroy
  has_many :respondents, dependent: :destroy

  has_value_object :user_type
  has_value_object :help_paying

  # Children additional details
  has_value_object :children_residence
  has_value_object :children_same_parents,         class_name: 'GenericYesNo'
  has_value_object :children_known_to_authorities, class_name: 'GenericYesNoUnknown'
  has_value_object :children_protection_plan,      class_name: 'GenericYesNoUnknown'
end
