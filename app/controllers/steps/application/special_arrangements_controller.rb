module Steps
  module Application
    class SpecialArrangementsController < Steps::ApplicationStepController
      def edit
        @form_object = SpecialArrangementsForm.build(current_c100_application)
      end

      def update
        update_and_advance(SpecialArrangementsForm, as: :special_arrangements)
      end
    end
  end
end
