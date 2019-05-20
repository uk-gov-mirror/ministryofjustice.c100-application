module Steps
  module Applicant
    class ContactDetailsForm < BaseForm
      attribute :home_phone, StrippedString
      attribute :mobile_phone, StrippedString
      attribute :email, NormalisedEmail

      validates_presence_of :mobile_phone
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
