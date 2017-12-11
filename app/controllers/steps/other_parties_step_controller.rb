module Steps
  class OtherPartiesStepController < StepController
    private

    def decision_tree_class
      C100App::OtherPartiesDecisionTree
    end
  end
end
