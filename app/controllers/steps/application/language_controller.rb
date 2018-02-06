module Steps
  module Application
    class LanguageController < Steps::ApplicationStepController
      def edit
        @form_object = LanguageForm.build(current_c100_application)
      end

      def update
        update_and_advance(LanguageForm, as: :language)
      end
    end
  end
end
