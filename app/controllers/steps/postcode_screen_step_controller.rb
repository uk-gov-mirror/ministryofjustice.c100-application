module Steps
  class PostcodeScreenStepController < StepController
    private

    def decision_tree_class
      C100App::PostcodeScreenDecisionTree
    end
  end
end
