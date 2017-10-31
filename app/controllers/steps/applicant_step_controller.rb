module Steps
  class ApplicantStepController < StepController
    private

    def decision_tree_class
      C100App::ApplicantDecisionTree
    end
  end
end
