module Steps
  module Screener
    class WrittenAgreementForm < BaseForm
      include SingleQuestionForm
      include HasOneAssociationForm

      has_one_association :screener_answers
      yes_no_attribute :written_agreement

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record_to_persist.update(
          written_agreement: written_agreement
        )
      end
    end
  end
end
