class Person < ApplicationRecord
  belongs_to :c100_application
  has_many :relationships, source: :person, dependent: :destroy

  # Using UUIDs as the record IDs. We can't trust sequential ordering by ID
  default_scope { order(created_at: :asc) }

  def full_name
    [first_name, last_name].compact.join(' ')
  end

  # Temporarily until we've migrated all records to the new first/last name format
  def full_name=(val)
    self[:last_name] = val
  end
end
