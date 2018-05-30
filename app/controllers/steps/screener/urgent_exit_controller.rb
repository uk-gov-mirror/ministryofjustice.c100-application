module Steps
  module Screener
    class UrgentExitController < Steps::ScreenerStepController
      def show
        @local_court = current_c100_application.court_from_screener_answers
      end
    end
  end
end
