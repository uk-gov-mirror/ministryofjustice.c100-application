class Child < ApplicationRecord
  belongs_to :c100_application

  has_value_object :gender

  scope :primary,   -> { where(kind: ChildrenType::PRIMARY.to_s) }
  scope :secondary, -> { where(kind: ChildrenType::SECONDARY.to_s) }
end
