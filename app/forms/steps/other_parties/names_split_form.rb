module Steps
  module OtherParties
    class NamesSplitForm < NamesSplitBaseForm
      private

      def record_collection
        @_record_collection ||= c100_application.other_parties
      end
    end
  end
end
