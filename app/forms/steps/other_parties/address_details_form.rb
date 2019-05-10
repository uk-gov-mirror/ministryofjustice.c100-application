module Steps
  module OtherParties
    class AddressDetailsForm < AddressBaseForm
      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        party = c100_application.other_parties.find_or_initialize_by(id: record_id)
        party.update(
          update_values
        )
      end
    end
  end
end
