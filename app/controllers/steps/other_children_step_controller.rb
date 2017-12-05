module Steps
  class OtherChildrenStepController < StepController
    private

    def decision_tree_class
      C100App::OtherChildrenDecisionTree
    end
  end
end
