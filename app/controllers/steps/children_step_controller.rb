module Steps
  class ChildrenStepController < StepController
    private

    def decision_tree_class
      C100App::ChildrenDecisionTree
    end
  end
end
