class Respondent < ApplicationRecord
  belongs_to :c100_application

  has_value_object :has_previous_name
  has_value_object :gender
end
