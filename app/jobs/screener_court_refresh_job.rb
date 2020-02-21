class ScreenerCourtRefreshJob < ApplicationJob
  queue_as :default

  def perform(screener)
    screener.refresh_local_court!
  end
end
