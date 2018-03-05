module SavepointStep
  extend ActiveSupport::Concern

  included do
    before_action :mark_in_progress, only: [:update]
    before_action :save_application_for_later, if: :user_signed_in?, only: [:update]
  end

  private

  def update_navigation_stack
    # Reset the navigation_stack to clear the screening steps as these
    # are no longer needed.
    current_c100_application.navigation_stack = []
    super
  end

  def mark_in_progress
    # The step including this concern will mark the current application
    # as `in progress`, meaning it has passed the screening and can be drafted.
    current_c100_application.in_progress!
  end

  def save_application_for_later
    C100App::SaveApplicationForLater.new(
      current_c100_application, current_user
    ).save
  end
end
