module Steps
  module Completion
    class WhatNextController < Steps::CompletionStepController
      def show
        @court = court_from_screener_answers
      end

      protected

      def court_from_screener_answers
        Court.new.from_courtfinder_data!(
          current_c100_application.screener_answers.try(:local_court)
        )
      end
    end
  end
end
