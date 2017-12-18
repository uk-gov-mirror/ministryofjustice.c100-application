class Child < Person
  has_one :child_order, dependent: :destroy
  has_many :relationships, source: :child, dependent: :destroy
end
