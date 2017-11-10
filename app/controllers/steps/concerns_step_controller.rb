module Steps
  class ConcernsStepController < StepController
    private

    def decision_tree_class
      C100App::ConcernsDecisionTree
    end
  end
end
