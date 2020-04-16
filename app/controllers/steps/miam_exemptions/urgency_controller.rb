module Steps
  module MiamExemptions
    class UrgencyController < Steps::MiamExemptionsStepController
      def edit
        @form_object = UrgencyForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(UrgencyForm, as: :urgency)
      end

      private

      def additional_permitted_params
        [urgency: []]
      end
    end
  end
end
