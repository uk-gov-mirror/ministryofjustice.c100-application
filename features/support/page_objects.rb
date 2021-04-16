module C100
  module Test
    module PageObjects
      # @return [C100::Test::PageObjects::CookieManagementPage]
      def cookie_management_page
        CookieManagementPage.new
      end
    end
  end
end

World(C100::Test::PageObjects)
