module Steps
  module Application
    class HelpPayingController < Steps::ApplicationStepController
      def edit
        @form_object = HelpPayingForm.build(current_c100_application)
      end

      def update
        update_and_advance(HelpPayingForm, as: :help_paying)
      end
    end
  end
end
