module Steps
  module Completion
    class WhatNextController < Steps::CompletionStepController
      include CompletionStep

      def show
        @court = current_c100_application.court_from_screener_answers
        @form_object = Steps::Completion::EmailSubmissionForm.build(
          current_c100_application
        )
        @form_object.court_email = @court.email

        if @form_object.email_copy_to.blank?
          @form_object.email_copy_to = email_for_user
        end
      end

      private

      def email_for_user
        [
          current_user.try(:email),
          current_c100_application.user.try(:email),
          current_c100_application.applicants.first.try(:email)
        ].compact.first
      end
    end
  end
end
