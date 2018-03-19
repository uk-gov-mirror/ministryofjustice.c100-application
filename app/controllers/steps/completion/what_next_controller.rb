module Steps
  module Completion
    class WhatNextController < Steps::CompletionStepController
      include CompletionStep

      def show
        @court = court_from_screener_answers
        @local_court = local_court
      end

      private

      # TODO: I don't understand why these two different ways of retrieving the court
      # data? Can we just get everything with the first (or the second) one?

      def court_from_screener_answers
        Court.new.from_courtfinder_data!(
          current_c100_application.screener_answers.try(:local_court)
        )
      end

      def local_court
        Court.new(current_c100_application.screener_answers.try(:local_court))
      end
    end
  end
end
