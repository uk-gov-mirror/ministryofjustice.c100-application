module Steps
  module Screener
    class LegalRepresentationForm < BaseForm
      include SingleQuestionForm
      include HasOneAssociationForm

      has_one_association :screener_answers
      yes_no_attribute :legal_representation

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record_to_persist.update(
          legal_representation: legal_representation
        )
      end
    end
  end
end
