module Steps
  module OtherChildren
    class NamesForm < BaseNamesForm
      private

      def record_collection
        @_record_collection ||= c100_application.other_children
      end
    end
  end
end
