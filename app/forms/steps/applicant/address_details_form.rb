module Steps
  module Applicant
    class AddressDetailsForm < AddressBaseForm
      attribute :residence_requirement_met, YesNo
      attribute :residence_history, String

      validates_presence_of :country, if: :validate_split_address?

      validates_inclusion_of :residence_requirement_met, in: GenericYesNo.values
      validates_presence_of :residence_history, if: -> { residence_requirement_met&.no? }

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        applicant = c100_application.applicants.find_or_initialize_by(id: record_id)
        applicant.update(
          update_values.merge(
            residence_requirement_met: residence_requirement_met,
            residence_history: residence_history,
          )
        )
      end
    end
  end
end
