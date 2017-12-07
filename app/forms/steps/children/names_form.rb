module Steps
  module Children
    class NamesForm < BaseNamesForm
      def self.name_attribute
        :name
      end

      private

      def record_collection
        @_record_collection ||= c100_application.children
      end
    end
  end
end
