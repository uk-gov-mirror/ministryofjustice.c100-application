module Steps
  module Screener
    class WrittenAgreementController < Steps::ScreenerStepController
      def edit
        @form_object = WrittenAgreementForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(WrittenAgreementForm)
      end
    end
  end
end
