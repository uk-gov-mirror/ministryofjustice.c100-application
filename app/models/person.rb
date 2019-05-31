class Person < ApplicationRecord
  belongs_to :c100_application
  has_many :relationships, source: :person, dependent: :destroy

  store_accessor :address_data,
                 :address_line_1, :address_line_2, :town, :country, :postcode

  # Using UUIDs as the record IDs. We can't trust sequential ordering by ID
  default_scope { order(created_at: :asc) }

  def full_name
    [first_name, last_name].compact.join(' ')
  end

  def full_address
    return address unless split_address?

    # Ensure, no matter the order of the keys in the hash, we return the values
    # in a predictable order, matching the `store_accessor` declaration.
    address_data.symbolize_keys.values_at(
      *self.class.stored_attributes.fetch(:address_data)
    ).presence_join(', ')
  end

  # Until we've migrated all database records to the new address form
  # structure, we must maintain backward-compatibility. Only c100 records
  # greater than this version will be eligible for the new split format.
  #
  def split_address?
    c100_application.version > 2
  end
end
