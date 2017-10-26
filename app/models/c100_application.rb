class C100Application < ApplicationRecord
  belongs_to :user, optional: true, dependent: :destroy

  has_value_object :case_type
end
