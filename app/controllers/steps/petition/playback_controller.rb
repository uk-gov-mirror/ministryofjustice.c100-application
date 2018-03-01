module Steps
  module Petition
    class PlaybackController < Steps::PetitionStepController
      def show
        @petition = PetitionPresenter.new(
          current_c100_application
        )
      end
    end
  end
end
