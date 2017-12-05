class Child < ApplicationRecord
  belongs_to :c100_application

  has_value_object :gender

  scope :principal, -> { where(kind: ChildrenType::PRINCIPAL.to_s) }
  scope :secondary, -> { where(kind: ChildrenType::SECONDARY.to_s) }
end
