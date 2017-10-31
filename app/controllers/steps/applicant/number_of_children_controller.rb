module Steps
  module Applicant
    class NumberOfChildrenController < Steps::ApplicantStepController
      def edit
        @form_object = NumberOfChildrenForm.new(
          c100_application: current_c100_application,
          number_of_children: current_c100_application.number_of_children
        )
      end

      def update
        update_and_advance(NumberOfChildrenForm)
      end
    end
  end
end
