module Steps
  class OtherPartiesStepController < CrudStepController
    private

    def decision_tree_class
      C100App::OtherPartiesDecisionTree
    end

    def names_form_class
      OtherParties::NamesSplitForm
    end

    def record_collection
      @_record_collection ||= current_c100_application.other_parties
    end
  end
end
