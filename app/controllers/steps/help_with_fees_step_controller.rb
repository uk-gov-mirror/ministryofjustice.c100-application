module Steps
  class HelpWithFeesStepController < StepController
    private

    def decision_tree_class
      C100App::HelpWithFeesDecisionTree
    end
  end
end
