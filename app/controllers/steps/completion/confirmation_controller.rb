module Steps
  module Completion
    class ConfirmationController < Steps::CompletionStepController
      include CompletionStep

      def show
        @court = court_from_screener_answers
        @local_court = local_court
      end
    end
  end
end
