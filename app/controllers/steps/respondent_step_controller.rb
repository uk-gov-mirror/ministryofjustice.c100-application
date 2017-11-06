module Steps
  class RespondentStepController < StepController
    private

    def decision_tree_class
      C100App::RespondentDecisionTree
    end
  end
end
