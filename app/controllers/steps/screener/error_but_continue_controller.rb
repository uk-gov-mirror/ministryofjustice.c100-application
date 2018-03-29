module Steps
  module Screener
    class ErrorButContinueController < Steps::ScreenerStepController
      def show
        @courtfinder_ok = begin
          C100App::CourtfinderAPI.new.is_ok?
        rescue SocketError
          false
        end
      end
    end
  end
end
