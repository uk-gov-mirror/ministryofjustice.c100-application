module Steps
  module Applicant
    class NamesController < Steps::ApplicantStepController
      include CrudStep
      include NamesCrudStep

      private

      def form_class
        NamesForm
      end

      def record_collection
        @_record_collection ||= current_c100_application.applicants
      end
    end
  end
end
