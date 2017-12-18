class Child < Person
  has_one :child_order, dependent: :destroy
end
