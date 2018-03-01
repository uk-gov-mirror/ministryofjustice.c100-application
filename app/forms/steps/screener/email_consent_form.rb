module Steps
  module Screener
    class EmailConsentForm < BaseForm
      include SingleQuestionForm
      include HasOneAssociationForm

      has_one_association   :screener_answers
      yes_no_attribute      :email_consent, reset_when_no: [:email_address]
      attribute             :email_address, NormalisedEmailType
      validates             :email_address, email: true, if: -> { email_consent&.yes? }

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record_to_persist.update(
          email_consent: email_consent,
          email_address: email_address
        )
      end
    end
  end
end
