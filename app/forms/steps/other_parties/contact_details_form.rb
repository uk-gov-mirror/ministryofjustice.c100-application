module Steps
  module OtherParties
    class ContactDetailsForm < BaseForm
      attribute :address, StrippedString
      attribute :postcode, StrippedString
      attribute :postcode_unknown, Boolean

      validates_presence_of :postcode, unless: :postcode_unknown?

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        party = c100_application.other_parties.find_or_initialize_by(id: record_id)
        party.update(
          attributes_map
        )
      end
    end
  end
end
