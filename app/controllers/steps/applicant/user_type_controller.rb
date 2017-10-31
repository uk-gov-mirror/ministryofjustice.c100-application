module Steps
  module Applicant
    class UserTypeController < Steps::ApplicantStepController
      include StartingPointStep

      def edit
        @form_object = UserTypeForm.new(
          c100_application: current_c100_application,
          user_type: current_c100_application.user_type
        )
      end

      def update
        update_and_advance(UserTypeForm)
      end
    end
  end
end
