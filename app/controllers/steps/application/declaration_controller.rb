module Steps
  module Application
    class DeclarationController < Steps::ApplicationStepController
      def edit
        @form_object = DeclarationForm.new(
          c100_application: current_c100_application,
          declaration_made: current_c100_application.declaration_made
        )
      end

      def update
        update_and_advance(DeclarationForm, as: :declaration)
      end
    end
  end
end
