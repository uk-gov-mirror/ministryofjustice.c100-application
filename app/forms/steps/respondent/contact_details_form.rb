module Steps
  module Respondent
    class ContactDetailsForm < BaseForm
      attribute :address, StrippedString
      attribute :address_unknown, Boolean
      attribute :home_phone, StrippedString
      attribute :mobile_phone, StrippedString
      attribute :mobile_phone_unknown, Boolean
      attribute :email, NormalisedEmail
      attribute :email_unknown, Boolean
      attribute :residence_requirement_met, YesNoUnknown
      attribute :residence_history, String

      validates_presence_of :address,      unless: :address_unknown?
      validates_presence_of :mobile_phone, unless: :mobile_phone_unknown?
      validates_presence_of :email,        unless: :email_unknown?

      validates_inclusion_of :residence_requirement_met, in: GenericYesNoUnknown.values
      validates_presence_of  :residence_history, if: -> { residence_requirement_met&.no? }

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        respondent = c100_application.respondents.find_or_initialize_by(id: record_id)
        respondent.update(
          attributes_map
        )
      end
    end
  end
end
