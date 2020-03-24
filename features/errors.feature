Feature: Errors
  Background:
    When I visit "/"
    Given I click the "Check eligibility" link

  @happy_path
  Scenario: I don't fill out the postcode field
    Given I click the "Continue" button

    Then I should be on "/steps/screener/postcode"
    And Page has title "Error: Where the children live - Apply to court about child arrangements - GOV.UK"
    And I should see "There is a problem on this page" in the error summary
    And I should see a "Enter a full postcode, with or without a space" link to "#steps-screener-postcode-form-children-postcodes-field-error"

    Then I click the "Enter a full postcode, with or without a space" link
    And I should see "Enter a full postcode, with or without a space" error in the form
    And "#steps_screener_postcode_form_children_postcodes" has focus
