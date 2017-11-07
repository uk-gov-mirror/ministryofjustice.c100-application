module Steps
  module Applicant
    class PersonalDetailsController < Steps::ApplicantStepController
      include CrudStep

      def edit
        @form_object = PersonalDetailsForm.new(
          c100_application: current_c100_application,
          record_id: current_record.id,
          full_name: current_record.full_name,
          has_previous_name: current_record.has_previous_name,
          previous_full_name: current_record.previous_full_name,
          gender: current_record.gender,
          dob: current_record.dob,
          birthplace: current_record.birthplace,
          address: current_record.address,
          postcode: current_record.postcode,
          home_phone: current_record.home_phone,
          mobile_phone: current_record.mobile_phone,
          email: current_record.email
        )
      end

      def update
        update_and_advance(
          PersonalDetailsForm,
          record_id: current_record.id,
          as: params.fetch(:button, :applicants_finished)
        )
      end

      private

      def record_collection
        @_record_collection ||= current_c100_application.applicants
      end
    end
  end
end
