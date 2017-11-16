class CourtOrder < ApplicationRecord
  belongs_to :c100_application

  has_value_object :non_molestation,                       class_name: 'GenericYesNo'
  has_value_object :non_molestation_is_current,            class_name: 'GenericYesNo'

  has_value_object :occupation,                            class_name: 'GenericYesNo'
  has_value_object :occupation_is_current,                 class_name: 'GenericYesNo'

  has_value_object :forced_marriage_protection,            class_name: 'GenericYesNo'
  has_value_object :forced_marriage_protection_is_current, class_name: 'GenericYesNo'

  has_value_object :restraining,                           class_name: 'GenericYesNo'
  has_value_object :restraining_is_current,                class_name: 'GenericYesNo'

  has_value_object :injunctive,                            class_name: 'GenericYesNo'
  has_value_object :injunctive_is_current,                 class_name: 'GenericYesNo'

  has_value_object :undertaking,                           class_name: 'GenericYesNo'
  has_value_object :undertaking_is_current,                class_name: 'GenericYesNo'
end
