Feature: Screener
  Background:
    When I visit "/"
    Then I should see "Use this service to make an application for child arrangements in England or Wales"

  @happy_path
  Scenario: Complete the screener
    Given I click the "Check eligibility" link

    Then I should see "Where do the children live?"
    And I fill in "Postcode" with "MK9 3DX"
    And I click the "Continue" button

    Then I should see "Are you a parent of the children or a solicitor representing a parent?"
    And I choose "Yes"

    Then I should see "Do you have a signed draft court order you want the court to consider making legally binding?"
    And I choose "No"

    Then I should see "You’re eligible to apply online"

    And I click the "Continue" link
    Then I should see "Before you start your application"

    And I click the "Start application" link
    Then I should see "What you’ll need to complete your application"

    And I click the "Continue" link
    Then I should see "How long it takes to apply"

    And I click the "Continue" link
    Then I should see "Are the children involved in any emergency protection, care or supervision proceedings (or have they been)?"

  @unhappy_path
  Scenario: Postcode not eligible
    Given I click the "Check eligibility" link

    Then I should see "Where do the children live?"
    And I fill in "Postcode" with "ZE2 9TE"
    And I click the "Continue" button

    Then I should see "Sorry, you cannot apply online"
    And I should see a "Download the form (PDF)" link to "https://formfinder.hmctsformfinder.justice.gov.uk/c100-eng.pdf"

  @unhappy_path
  Scenario: Postcode not recognised
    Given I click the "Check eligibility" link

    Then I should see "Where do the children live?"
    And I fill in "Postcode" with "GU2 9JE"
    And I click the "Continue" button

    Then I should see "Something went wrong"
    And I should see a "Download the form (PDF)" link to "https://formfinder.hmctsformfinder.justice.gov.uk/c100-eng.pdf"
    And I should see a "Go back and try again" link to "/steps/screener/postcode"

  @unhappy_path
  Scenario: Not a parent
    Given I click the "Check eligibility" link
    Then I should see "Where do the children live?"

    And I fill in "Postcode" with "MK9 3DX"
    And I click the "Continue" button

    Then I should see "Are you a parent of the children or a solicitor representing a parent?"
    And I choose "No"

    Then I should see "Sorry, you’re not eligible to apply online"
    And I should see a "Download the form (PDF)" link to "https://formfinder.hmctsformfinder.justice.gov.uk/c100-eng.pdf"
