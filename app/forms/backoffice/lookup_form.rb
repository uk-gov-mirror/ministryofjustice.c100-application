module Backoffice
  class LookupForm
    include ActiveModel::Model

    attr_accessor :reference_code, :email_address

    validates_presence_of :reference_code
    validate :reference_code_format

    # Email is optional, and in some places we don't even ask for it
    validates :email_address, email: true, allow_blank: true

    def initialize(*args)
      super

      # It is very common to copy&paste, introducing some extraneous spacing.
      # In order to reduce this silly mistake, we pro-actively remove blanks,
      # instead of returning no results or even worse, an error.
      #
      @reference_code.try(:strip!)
      @email_address.try(:strip!)
    end

    private

    def reference_code_format
      # Very high level format validation for now, as the reference codes
      # might need to change soon with online payments.
      errors.add(:reference_code, :invalid) unless reference_code.count('/') > 1
    end
  end
end
