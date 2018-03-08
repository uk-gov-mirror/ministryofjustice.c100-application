class Person < ApplicationRecord
  belongs_to :c100_application
  has_many :relationships, source: :person, dependent: :destroy

  # Using UUIDs as the record IDs. We can't trust sequential ordering by ID
  default_scope { order(created_at: :asc) }
end
