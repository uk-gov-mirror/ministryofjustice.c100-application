module Steps
  module Screener
    class StartController < Steps::ScreenerStepController
      skip_before_action :check_c100_application_presence
      before_action :reset_c100_application_session

      def show; end
    end
  end
end
