module Steps
  module Respondent
    class PersonalDetailsController < Steps::RespondentStepController
      before_action :set_existing_respondents

      def edit
        @form_object = PersonalDetailsForm.new(
          c100_application: current_c100_application,
          record_id: current_respondent.id,
          full_name: current_respondent.full_name,
          has_previous_name: current_respondent.has_previous_name,
          previous_full_name: current_respondent.previous_full_name,
          gender: current_respondent.gender,
          dob: current_respondent.dob,
          dob_unknown: current_respondent.dob_unknown,
          birthplace: current_respondent.birthplace,
          address: current_respondent.address,
          postcode: current_respondent.postcode,
          postcode_unknown: current_respondent.postcode_unknown,
          home_phone: current_respondent.home_phone,
          mobile_phone: current_respondent.mobile_phone,
          mobile_phone_unknown: current_respondent.mobile_phone_unknown,
          email: current_respondent.email,
          email_unknown: current_respondent.email_unknown
        )
      end

      def update
        update_and_advance(
          PersonalDetailsForm,
          record_id: current_respondent.id,
          as: params.fetch(:button, :respondents_finished)
        )
      end

      def destroy
        current_respondent.destroy
        redirect_to action: :edit, id: current_c100_application.saved_respondents.first
      end

      private

      def current_respondent
        @_current_respondent ||= current_c100_application.respondents.find_or_initialize_by(id: params[:id])
      end

      def set_existing_respondents
        @existing_respondents = current_c100_application.saved_respondents
      end
    end
  end
end
