class Child < Minor
  has_one :child_order, dependent: :destroy
  has_one :child_residence, dependent: :destroy
end
