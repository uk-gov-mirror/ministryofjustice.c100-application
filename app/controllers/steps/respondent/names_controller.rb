module Steps
  module Respondent
    class NamesController < Steps::RespondentStepController
      include CrudStep
      include NamesCrudStep

      private

      def form_class
        NamesForm
      end

      def record_collection
        @_record_collection ||= current_c100_application.respondents
      end
    end
  end
end
