module SavepointStep
  extend ActiveSupport::Concern

  included do
    skip_before_action :check_application_not_screening
    before_action :mark_in_progress, only: [:update]
    before_action :save_application_for_later, if: :user_signed_in?, only: [:update]
  end

  private

  def update_navigation_stack
    # Points the navigation stack to the first page after the screener, so if the user
    # clicks the `back` link, they are not taken to start of the screener again.
    current_c100_application.navigation_stack = [entrypoint_v1_path]
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
