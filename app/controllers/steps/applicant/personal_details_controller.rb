module Steps
  module Applicant
    class PersonalDetailsController < Steps::ApplicantStepController
      def edit
        @form_object = PersonalDetailsForm.new(
          c100_application: current_c100_application,
          personal_details: current_c100_application.personal_details
        )
      end

      def update
        update_and_advance(PersonalDetailsForm)
      end
    end
  end
end
