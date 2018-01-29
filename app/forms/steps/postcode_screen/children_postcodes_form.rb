module Steps
  module PostcodeScreen
    class ChildrenPostcodesForm < BaseForm
      attribute :children_postcodes, String

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.update(
          children_postcodes: children_postcodes
        )
      end
    end
  end
end
