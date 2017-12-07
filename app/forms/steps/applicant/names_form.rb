module Steps
  module Applicant
    class NamesForm < BaseNamesForm
      private

      def record_collection
        @_record_collection ||= c100_application.applicants
      end
    end
  end
end
