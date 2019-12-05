Feature: Errors
  Background:
    When I visit "/"
    Given I click the "Check eligibility" link

  @happy_path
  Scenario: I don't fill out the postcode field
    Given I click the "Continue" button
    Then I should be on "/steps/screener/postcode"
    And Page has title "Error: Where the children live - Apply to court about child arrangements - GOV.UK"
    And I should see "There is a problem on this page" in a "h2" element
    And I should see a "Enter a full postcode, with or without a space" link to "#error_steps_screener_postcode_form_children_postcodes"
        
    Then I click the "Enter a full postcode, with or without a space" link
    And I should see "Enter a full postcode, with or without a space" in the form label
    And "#error_steps_screener_postcode_form_children_postcodes" has focus
