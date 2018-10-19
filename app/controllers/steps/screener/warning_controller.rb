module Steps
  module Screener
    class WarningController < Steps::ScreenerStepController
      skip_before_action :update_navigation_stack

      def show; end
    end
  end
end
