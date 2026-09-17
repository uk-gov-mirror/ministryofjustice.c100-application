module Steps
  class OpeningStepController < StepController
    skip_before_action :check_application_not_screening
    include StartingPointStep

    private

    def decision_tree_class
      C100App::OpeningDecisionTree
    end

    def not_enough_progress?
      !(navigation_stack.progressed? && %w[screening completed].exclude?(current_c100_application.status))
    end

    def is_attempting_restart?
      params[:new].present?
    end

    def is_attempting_change?
      params[:change].present?
    end

    def in_progress_enough?
      navigation_stack.progressed? && %w[screening completed].exclude?(current_c100_application.status)
    end

    def existing_application_warning
      return unless current_c100_application
      return if not_enough_progress?
      return if is_attempting_restart?

      redirect_to steps_opening_warning_path, allow_other_host: true
    end
  end
end
