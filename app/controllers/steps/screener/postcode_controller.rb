module Steps
  module Screener
    class PostcodeController < Steps::ScreenerStepController
      include StartingPointStep

      def edit
        @form_object = PostcodeForm.build(current_c100_application)
      end

      def update
        update_and_advance(PostcodeForm)
      end
    end
  end
end
