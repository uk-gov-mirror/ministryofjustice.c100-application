module Steps
  module Screener
    class ErrorButContinueController < Steps::ScreenerStepController
      def show
        @courtfinder_ok = C100App::CourtfinderAPI.new.is_ok?
      end
    end
  end
end
