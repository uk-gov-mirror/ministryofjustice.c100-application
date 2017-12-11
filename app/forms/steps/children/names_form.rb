module Steps
  module Children
    class NamesForm < NamesBaseForm
      private

      def record_collection
        @_record_collection ||= c100_application.children
      end
    end
  end
end
