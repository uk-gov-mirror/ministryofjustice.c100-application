module Steps
  module Completion
    class ConfirmationController < Steps::CompletionStepController
      include CompletionStep

      def show
        @court = current_c100_application.court_from_screener_answers
      end
    end
  end
end
