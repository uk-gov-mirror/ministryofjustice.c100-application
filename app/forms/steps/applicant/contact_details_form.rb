module Steps
  module Applicant
    class ContactDetailsForm < BaseForm
      attribute :home_phone, StrippedString
      attribute :mobile_phone, StrippedString
      attribute :email, StrippedString

      # Note: we validate presence of these fields, but allow the applicant to enter
      # free text in case they do not want to disclose their phone or email address.
      # That is why we do not perform any further validation, other than presence
      # (do not validate the format of the phone or email, etc.)
      #
      validates_presence_of :mobile_phone,
                            :email

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
