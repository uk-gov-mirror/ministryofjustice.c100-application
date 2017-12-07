module Steps
  module Children
    class NamesForm < BaseNamesForm
      private

      def name_attribute
        :name
      end

      def record_collection
        @_record_collection ||= c100_application.children
      end
    end
  end
end
