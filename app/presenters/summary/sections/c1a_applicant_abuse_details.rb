module Summary
  module Sections
    class C1aApplicantAbuseDetails < C1aBaseAbuseDetails
      def name
        :c1a_applicant_abuse_details
      end

      def subject
        AbuseSubject::APPLICANT
      end
    end
  end
end
