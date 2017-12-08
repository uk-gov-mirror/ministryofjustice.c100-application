module Steps
  module Respondent
    class NamesForm < NamesBaseForm
      private

      def record_collection
        @_record_collection ||= c100_application.respondents
      end
    end
  end
end
