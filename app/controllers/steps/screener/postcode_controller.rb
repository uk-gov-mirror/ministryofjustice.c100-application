module Steps
  module Screener
    class PostcodeController < Steps::ScreenerStepController
      include StartingPointStep

      def edit
        @form_object = PostcodeForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(PostcodeForm)
      end
    end
  end
end
