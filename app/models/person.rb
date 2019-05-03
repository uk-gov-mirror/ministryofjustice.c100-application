class Person < ApplicationRecord
  belongs_to :c100_application
  has_many :relationships, source: :person, dependent: :destroy

  # Using UUIDs as the record IDs. We can't trust sequential ordering by ID
  default_scope { order(created_at: :asc) }

  def full_name
    [first_name, last_name].compact.join(' ')
  end

  def full_address
    return address unless split_address?
    address_data.values.reject(&:blank?).join(', ')
  end

  # Until we've migrated all database records to the new address form
  # structure, we must maintain backward-compatibility. Only c100 records
  # greater than this version will be eligible for the new split format.
  #
  def split_address?
    (c100_application.version > 2 || ENV.key?("SPLIT_ADDRESS")) || ENV.key?("DEV_TOOLS_ENABLED")
  end
end
