module Steps
  module Respondent
    class ContactDetailsForm < BaseForm
      attribute :email, NormalisedEmail
      attribute :email_unknown, Boolean
      attribute :phone_number, StrippedString
      attribute :phone_number_unknown, Boolean

      validates :email, email: true, unless: :email_unknown?
      validates_presence_of :email, unless: :email_unknown?
      validates_presence_of :phone_number, unless: :phone_number_unknown?
      validates :phone_number, phone_number: true, unless: :phone_number_unknown?
      validates :email, unknown_respondent_input: true, if: :email_unknown?
      validates :phone_number, unknown_respondent_input: true, if: :phone_number_unknown?

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
