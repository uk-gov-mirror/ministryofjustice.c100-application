module Steps
  module Screener
    class EmailConsentForm < BaseForm
      include SingleQuestionForm
      include HasOneAssociationForm

      has_one_association   :screener_answers
      yes_no_attribute      :email_consent, reset_when_no: [:email_address]
      attribute             :email_address, NormalisedEmail
      validates             :email_address, email: true, if: -> { email_consent&.yes? }
    end
  end
end
