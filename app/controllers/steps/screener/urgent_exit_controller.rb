module Steps
  module Screener
    class UrgentExitController < Steps::ScreenerStepController
      def show
        @local_court = Court.new(current_c100_application.screener_answers.try(:local_court))
      end
    end
  end
end
