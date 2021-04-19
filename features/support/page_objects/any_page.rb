require_relative './any_page'
module C100
  module Test
    module PageObjects
      class AnyPage < SitePrism::Page

        def has_google_analytics_enabled?
          wait_until_true(timeout: 100) do
            !google_analytics_enabled
          end
        end

        def has_cookie_preferences_updated_message?
          notification_banner.has_content?(text: "You've set your cookie preferences")
        end

        section :notification_banner, '.govuk-notification-banner' do
          element :title, '.govuk-notification-banner__header.govuk-notification-banner__title'
          element :content, '.govuk-notification-banner__content .govuk-notification-banner__heading'
        end


        private

        def google_analytics_enabled
          page.evaluate_script("window['ga-disable-#{Rails.application.config.x.analytics_tracking_id}']")
        end

        def wait_until_true(timeout: Capybara.default_max_wait_time, sleep: 0.1)
          Timeout.timeout(timeout) do
            loop do
              break true if yield
              sleep sleep
            end
          end
        end
      end
    end
  end
end
