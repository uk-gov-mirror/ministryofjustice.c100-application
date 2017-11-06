module Steps
  module Applicant
    class PersonalDetailsController < Steps::ApplicantStepController
      before_action :set_existing_applicants

      def edit
        @form_object = PersonalDetailsForm.new(
          c100_application: current_c100_application,
          record_id: current_applicant.id,
          full_name: current_applicant.full_name,
          has_previous_name: current_applicant.has_previous_name,
          previous_full_name: current_applicant.previous_full_name,
          gender: current_applicant.gender,
          dob: current_applicant.dob,
          birthplace: current_applicant.birthplace,
          address: current_applicant.address,
          postcode: current_applicant.postcode,
          home_phone: current_applicant.home_phone,
          mobile_phone: current_applicant.mobile_phone,
          email: current_applicant.email
        )
      end

      def update
        update_and_advance(
          PersonalDetailsForm,
          record_id: current_applicant.id,
          as: params.fetch(:button, :applicants_finished)
        )
      end

      def destroy
        current_applicant.destroy
        redirect_to action: :edit, id: current_c100_application.saved_applicants.first
      end

      private

      def current_applicant
        @_current_applicant ||= current_c100_application.applicants.find_or_initialize_by(id: params[:id])
      end

      def set_existing_applicants
        @existing_applicants = current_c100_application.saved_applicants
      end
    end
  end
end
