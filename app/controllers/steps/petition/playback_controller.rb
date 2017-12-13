module Steps
  module Petition
    class PlaybackController < Steps::PetitionStepController
      def show
        @petition = PetitionPresenter.new(
          current_c100_application.asking_order
        )
      end
    end
  end
end
