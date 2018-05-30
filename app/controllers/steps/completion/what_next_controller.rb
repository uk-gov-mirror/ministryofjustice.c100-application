module Steps
  module Completion
    class WhatNextController < Steps::CompletionStepController
      include CompletionStep

      def show
        @court = current_c100_application.court_from_screener_answers
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
