module Steps
  class NatureOfApplicationStepController < StepController
    private

    def decision_tree_class
      CaseTypeDecisionTree
    end
  end
end
