module Steps
  class ScreenerStepController < StepController
    private

    def decision_tree_class
      C100App::ScreenerDecisionTree
    end
  end
end
