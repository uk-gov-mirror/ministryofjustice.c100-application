module Steps
  class NatureOfApplicationStepController < StepController
    private

    def decision_tree_class
      C100App::CaseTypeDecisionTree
    end
  end
end
