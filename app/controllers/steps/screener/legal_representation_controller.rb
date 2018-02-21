module Steps
  module Screener
    class LegalRepresentationController < Steps::ScreenerStepController
      def edit
        @form_object = LegalRepresentationForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(LegalRepresentationForm)
      end
    end
  end
end
