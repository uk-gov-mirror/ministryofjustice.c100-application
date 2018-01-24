module Steps
  module PostcodeScreen
    class ChildrenPostcodesForm < BaseForm
      include SingleQuestionForm

      attribute :children_postcodes, String

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record_to_persist.update(
          attributes_map
        )
      end
    end
  end
end
