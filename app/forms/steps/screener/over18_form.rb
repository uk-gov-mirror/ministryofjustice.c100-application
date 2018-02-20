module Steps
  module Screener
    class Over18Form < BaseForm
      include SingleQuestionForm
      include HasOneAssociationForm

      has_one_association :screener_answers
      yes_no_attribute :over18

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record_to_persist.update(
          over18: over18
        )
      end
    end
  end
end
