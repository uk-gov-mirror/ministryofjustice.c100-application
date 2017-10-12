class Steps::NatureOfApplicationStepController < StepController
  private

  def decision_tree_class
    ApplicationTypeDecisionTree
  end
end
