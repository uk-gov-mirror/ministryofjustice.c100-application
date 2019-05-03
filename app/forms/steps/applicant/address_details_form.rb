module Steps
  module Applicant
    class AddressDetailsForm < BaseForm
      attribute :address, StrippedString

      attribute :address_line_1, String
      attribute :address_line_2, String
      attribute :town, String
      attribute :country, String
      attribute :postcode, String

      attribute :residence_requirement_met, YesNo
      attribute :residence_history, String

      validates_presence_of :address, unless: :split_address?

      validates_presence_of :address_line_1, if: :split_address?
      validates_presence_of :postcode, if: :split_address?

      validates_inclusion_of :residence_requirement_met, in: GenericYesNo.values
      validates_presence_of  :residence_history, if: -> { residence_requirement_met&.no? }

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        applicant = c100_application.applicants.find_or_initialize_by(id: record_id)
        applicant.update(
          update_values
        )
      end

      def update_values
        return address_split_values if split_address?
        address_values
      end

      def address_values
        {
          address: address,
          residence_requirement_met: residence_requirement_met,
          residence_history: residence_history
        }
      end

      def address_split_values
        {
          address_data: address_hash,
          residence_requirement_met: residence_requirement_met,
          residence_history: residence_history
        }
      end

      def address_hash
        {
          address_line_1: address_line_1,
          address_line_2: address_line_2,
          town: town,
          country: country,
          postcode: postcode
        }
      end
    end
  end
end
