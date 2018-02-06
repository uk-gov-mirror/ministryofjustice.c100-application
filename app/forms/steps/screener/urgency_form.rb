module Steps
  module Screener
    class UrgencyForm < BaseForm
      include SingleQuestionForm
      include HasOneAssociationForm

      has_one_association :screener_answers
      yes_no_attribute :urgent

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record_to_persist.update(
          urgent: urgent
        )
      end
    end
  end
end
