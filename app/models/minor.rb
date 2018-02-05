class Minor < Person
  has_many :relationships, source: :minor, dependent: :destroy
end
