module Summary
  module Sections
    class C1aChildrenAbuseDetails < C1aBaseAbuseDetails
      def name
        :c1a_children_abuse_details
      end

      def subject
        AbuseSubject::CHILDREN
      end
    end
  end
end
