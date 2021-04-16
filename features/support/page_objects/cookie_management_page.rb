module C100
  module Test
    module PageObjects
      class CookieManagementPage < SitePrism::Page
        include EtTestHelpers::Page

        gds_radios :analytics_question, label: 'Do you want to accept analytics cookies?'

      end
    end
  end
end
