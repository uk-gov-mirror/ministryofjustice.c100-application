module Steps
  module Applicant
    class AddressDetailsForm < BaseForm
      attribute :address, StrippedString
      attribute :residence_requirement_met, YesNo
      attribute :residence_history, String

      validates_presence_of :address

      validates_inclusion_of :residence_requirement_met, in: GenericYesNo.values
      validates_presence_of  :residence_history, if: -> { residence_requirement_met&.no? }

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        applicant = c100_application.applicants.find_or_initialize_by(id: record_id)
        applicant.update(
          attributes_map
        )
      end
    end
  end
end
