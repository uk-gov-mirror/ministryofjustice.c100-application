class Child < ApplicationRecord
  belongs_to :c100_application

  has_value_object :gender
end
