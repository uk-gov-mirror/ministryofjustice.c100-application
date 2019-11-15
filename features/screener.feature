Feature: Screener
  Background:
    When I visit "/"
    Then I should see "We’re trialling a new online service to apply to court about child arrangements"

  @happy_path
  Scenario: Complete the screener
    Given I click the "Check now" link

    Then I should see "Where do the children live?"
    And I fill in "Postcode" with "MK9 3DX"
    And I click the "Continue" button

    Then I should see "Are you a parent of the child or children?"
    And I choose "Yes"

    Then I should see "Are you and the other parent both over 18?"
    And I choose "Yes"

    Then I should see "Do you have a solicitor?"
    And I choose "No"

    Then I should see "Do you have a signed draft court order you want the court to consider making legally binding?"
    And I choose "No"

    Then I should see "Are you willing to be contacted by email about your experience using this service?"
    And I choose "Yes" and fill in "Email address" with "smoketest@example.com"

    Then I should see "You're eligible to apply online"

  @unhappy_path
  Scenario: Postcode not eligible
    Given I click the "Check now" link

    Then I should see "Where do the children live?"
    And I fill in "Postcode" with "M60 9DJ"
    And I click the "Continue" button

    Then I should see "Sorry, you're not eligible to apply online"
    And I should see a "Download the form (PDF)" link to "https://formfinder.hmctsformfinder.justice.gov.uk/c100-eng.pdf"

  @unhappy_path
  Scenario: Postcode not recognised
    Given I click the "Check now" link

    Then I should see "Where do the children live?"
    And I fill in "Postcode" with "GU2 9JE"
    And I click the "Continue" button

    Then I should see "Something went wrong"
    And I should see a "Download the form (PDF)" link to "https://formfinder.hmctsformfinder.justice.gov.uk/c100-eng.pdf"
    And I should see a "Go back and try again" link to "/steps/screener/postcode"

  @unhappy_path
  Scenario: Not a parent
    Given I click the "Check now" link
    Then I should see "Where do the children live?"

    And I fill in "Postcode" with "MK9 3DX"
    And I click the "Continue" button

    Then I should see "Are you a parent of the child or children?"
    And I choose "No"

    Then I should see "Sorry, you’re not eligible to apply online"
    And I should see a "Download the form (PDF)" link to "https://formfinder.hmctsformfinder.justice.gov.uk/c100-eng.pdf"

