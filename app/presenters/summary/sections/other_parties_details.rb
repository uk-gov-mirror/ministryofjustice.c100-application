module Summary
  module Sections
    class OtherPartiesDetails < PeopleDetails
      def name
        :other_parties_details
      end

      def record_collection
        c100.other_parties
      end
    end
  end
end
