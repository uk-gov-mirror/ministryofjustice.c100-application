module Steps
  module Applicant
    class ContactDetailsForm < BaseForm
      attribute :address, StrippedString
      attribute :home_phone, StrippedString
      attribute :mobile_phone, StrippedString
      attribute :email, NormalisedEmail
      attribute :residence_requirement_met, YesNo
      attribute :residence_history, String

      validates_presence_of :address

      validates_inclusion_of :residence_requirement_met, in: GenericYesNo.values
      validates_presence_of  :residence_history, if: -> { residence_requirement_met&.no? }

      validates :email, email: true, allow_blank: true

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
