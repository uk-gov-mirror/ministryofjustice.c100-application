Feature: Cookie management
  Background:
    # Simply go to the home page and on to cookies
    Given I am on the home page
    And I click the "Continue" link
  Scenario: Cookie management page viewing the basics
    When I click the "Cookies" link
    Then I should see "Essential cookies"
    And I should see "Analytics cookies (optional)"
  Scenario: Default cookie preferences on the cookie management page
    When I click the "Cookies" link
    Then the analytics cookies radio buttons are defaulted to 'No'
    And analytics cookies are NOT allowed to be set
  Scenario: Allowing analytics cookies on the cookie management page
    When I click the "Cookies" link
    When I select 'Yes' for analytics cookies
    And click 'Save cookie settings'
    Then google analytics cookies are allowed to be set
    And a confirmation box will appear telling me that my settings have been saved
  Scenario: Not allowing analytics cookies on the cookie management page
    When I click the "Cookies" link
    When I select 'No' for analytics cookies
    And click 'Save cookie settings'
    Then google analytics cookies are NOT allowed to be set
    And a confirmation box will appear telling me that my settings have been saved


