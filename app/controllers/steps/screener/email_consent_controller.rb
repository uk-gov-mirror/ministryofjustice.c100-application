module Steps
  module Screener
    class EmailConsentController < Steps::ScreenerStepController
      def edit
        @form_object = EmailConsentForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(EmailConsentForm)
      end
    end
  end
end
