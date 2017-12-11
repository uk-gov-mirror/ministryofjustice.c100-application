module Steps
  module OtherParties
    class NamesForm < NamesBaseForm
      private

      def record_collection
        @_record_collection ||= c100_application.other_parties
      end
    end
  end
end
