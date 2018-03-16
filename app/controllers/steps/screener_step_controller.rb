module Steps
  class ScreenerStepController < StepController
    skip_before_action :check_application_not_screening

    private

    def decision_tree_class
      C100App::ScreenerDecisionTree
    end
  end
end
