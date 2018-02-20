module Steps
  module Screener
    class ParentForm < BaseForm
      include SingleQuestionForm
      include HasOneAssociationForm

      has_one_association :screener_answers
      yes_no_attribute :parent

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record_to_persist.update(
          parent: parent
        )
      end
    end
  end
end
