module Steps
  module Application
    class CheckYourAnswersController < Steps::ApplicationStepController
      before_action :set_presenter

      def edit
        @form_object = DeclarationForm.build(current_c100_application)
      end

      def update
        update_and_advance(DeclarationForm, as: step_name)
      end

      def resume; end

      private

      def set_presenter
        @presenter = Summary::HtmlPresenter.new(current_c100_application)
      end

      def step_name
        if current_c100_application.online_submission?
          :online_submission
        else
          :print_and_post_submission
        end
      end
    end
  end
end
