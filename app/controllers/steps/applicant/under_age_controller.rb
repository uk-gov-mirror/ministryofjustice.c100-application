module Steps
  module Applicant
    class UnderAgeController < Steps::ApplicantStepController
      def edit
        @form_object = Steps::Shared::UnderAgeForm.build(
          current_record, c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(
          Steps::Shared::UnderAgeForm,
          record: current_record,
          as: :under_age
        )
      end
    end
  end
end
