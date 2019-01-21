module Steps
  class ChildrenStepController < CrudStepController
    private

    def decision_tree_class
      C100App::ChildrenDecisionTree
    end

    # Until we've migrated all database records to the new first/last name
    # structure, we must maintain backward-compatibility. Only c100 records
    # with version greater than 1 will be eligible for the new split format.
    #
    def names_form_class
      return Children::NamesSplitForm if split_names?
      Children::NamesForm
    end

    def record_collection
      @_record_collection ||= current_c100_application.children
    end
  end
end
