module Steps
  module Screener
    class Over18Controller < Steps::ScreenerStepController
      def edit
        @form_object = Over18Form.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(Over18Form)
      end
    end
  end
end
