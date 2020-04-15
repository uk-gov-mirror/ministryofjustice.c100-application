module Steps
  module MiamExemptions
    class ProtectionController < Steps::MiamExemptionsStepController
      def edit
        @form_object = ProtectionForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(ProtectionForm, as: :protection)
      end

      private

      def additional_permitted_params
        [protection: []]
      end
    end
  end
end
