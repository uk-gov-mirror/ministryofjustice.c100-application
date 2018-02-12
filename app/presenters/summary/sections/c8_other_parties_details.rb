module Summary
  module Sections
    class C8OtherPartiesDetails < PeopleDetails
      def name
        :c8_other_parties_details
      end

      def show_header?
        true
      end

      def record_collection
        c100.other_parties
      end
    end
  end
end
