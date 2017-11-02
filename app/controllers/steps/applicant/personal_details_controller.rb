module Steps
  module Applicant
    class PersonalDetailsController < Steps::ApplicantStepController
      # rubocop:disable Metrics/AbcSize
      def edit
        @form_object = PersonalDetailsForm.new(
          c100_application: current_c100_application,
          applicant_id: current_applicant.id,
          full_name: current_applicant.full_name,
          has_previous_name: current_applicant.has_previous_name,
          previous_full_name: current_applicant.previous_full_name,
          gender: current_applicant.gender,
          birthplace: current_applicant.birthplace,
          address: current_applicant.address,
          postcode: current_applicant.postcode,
          home_phone: current_applicant.home_phone,
          mobile_phone: current_applicant.mobile_phone,
          email: current_applicant.email
        )
      end
      # rubocop:enable Metrics/AbcSize

      def update
        update_and_advance(PersonalDetailsForm, as: :personal_details)
      end

      private

      # TODO: for now, hardcoded to get the first one if exists.
      def current_applicant
        @_current_applicant ||= current_c100_application.applicants.first_or_initialize
      end
    end
  end
end
