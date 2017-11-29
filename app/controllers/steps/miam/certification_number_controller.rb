module Steps
  module Miam
    class CertificationNumberController < Steps::MiamStepController
      def edit
        @form_object = CertificationNumberForm.new(
          c100_application: current_c100_application,
          miam_certification_number: current_c100_application.miam_certification_number
        )
      end

      def update
        update_and_advance(CertificationNumberForm)
      end
    end
  end
end
