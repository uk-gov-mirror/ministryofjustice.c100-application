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
    # Ensure, no matter the order of the keys in the hash, we return the values
    # in a predictable order, matching the `store_accessor` declaration.
    address_data.symbolize_keys.values_at(
      *self.class.stored_attributes.fetch(:address_data)
    ).presence_join(', ')
  end
end
