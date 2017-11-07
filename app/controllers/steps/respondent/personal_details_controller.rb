module Steps
  module Respondent
    class PersonalDetailsController < Steps::RespondentStepController
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
          dob_unknown: current_record.dob_unknown,
          birthplace: current_record.birthplace,
          address: current_record.address,
          postcode: current_record.postcode,
          postcode_unknown: current_record.postcode_unknown,
          home_phone: current_record.home_phone,
          mobile_phone: current_record.mobile_phone,
          mobile_phone_unknown: current_record.mobile_phone_unknown,
          email: current_record.email,
          email_unknown: current_record.email_unknown
        )
      end

      def update
        update_and_advance(
          PersonalDetailsForm,
          record_id: current_record.id,
          as: params.fetch(:button, :respondents_finished)
        )
      end

      private

      def record_collection
        @_record_collection ||= current_c100_application.respondents
      end
    end
  end
end
