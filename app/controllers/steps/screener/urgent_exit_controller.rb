module Steps
  module Screener
    class UrgentExitController < Steps::ScreenerStepController
      def show
        @local_court = current_c100_application.screener_answers_court
      end
    end
  end
end
