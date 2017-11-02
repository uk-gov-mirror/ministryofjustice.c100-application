class Applicant < ApplicationRecord
  belongs_to :c100_application

  has_value_object :has_previous_name, class_name: 'GenericYesNo'
  has_value_object :gender
end
