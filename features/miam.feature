Feature: MIAM journey
  Background:
    Given I have started an application
    Then I should see "Are the children involved in any emergency protection, care or supervision proceedings (or have they been)?"
    And I should see "Why we use the term ‘children’"
    And I should see the save draft button
    When I choose "No"
    Then I should see "Attending a Mediation Information and Assessment Meeting (MIAM)"
    And I check "I understand that I have to attend a MIAM or provide a valid reason for not attending."
    And I click the "Continue" button

  @happy_path
  Scenario: Applicant attended a MIAM
    Then I should see "Have you attended a MIAM?"
    And I choose "Yes"

    Then I should see "Have you got a document signed by the mediator?"
    And I choose "Yes"

    Then I should see "When did you attend the MIAM?"
    And I enter a valid MIAM date

    Then I should see "Enter details of MIAM certification"
    And I fill in "Mediator registration number (URN)" with "URN"
    And I fill in "Family mediation service name" with "Service name"
    And I fill in "Sole trader name" with "Sole trader name"
    And I click the "Continue" button

    Then I should see "MIAM attendance confirmation"

  @unhappy_path
  Scenario Outline: Applicant attended a MIAM but lacks the certificate
    Then I should see "Have you attended a MIAM?"
    And I choose "Yes"

    Then I should see "Have you got a document signed by the mediator?"
    And I choose "No"

    Then I should see "Do you have a valid reason for not attending a MIAM?"
    And I choose "<has_valid_reason>"
    Then I should see "<outcome_page_header>"

    Examples:
      | has_valid_reason | outcome_page_header                                       |
      | Yes              | Providing evidence of domestic violence or abuse concerns |
      | No               | Safety concerns                                           |

  @unhappy_path
  Scenario Outline: Applicant attended a MIAM but the certificate is too old
    Then I should see "Have you attended a MIAM?"
    And I choose "Yes"

    Then I should see "Have you got a document signed by the mediator?"
    And I choose "Yes"

    Then I should see "When did you attend the MIAM?"
    And I enter the date 15-05-2018
    And I click the "Continue" button

    Then I should see "Your MIAM is out of date"
    And I click the "Confirm and continue" link

    Then I should see "Do you have a valid reason for not attending a MIAM?"
    And I choose "<has_valid_reason>"
    Then I should see "<outcome_page_header>"

    Examples:
      | has_valid_reason | outcome_page_header                                       |
      | Yes              | Providing evidence of domestic violence or abuse concerns |
      | No               | Safety concerns                                           |

  @unhappy_path
  Scenario Outline: Applicant did not attend a MIAM
    Then I should see "Have you attended a MIAM?"
    And I choose "No"

    Then I should see "Do you have a valid reason for not attending a MIAM?"
    And I choose "<has_valid_reason>"
    Then I should see "<outcome_page_header>"

    Examples:
      | has_valid_reason | outcome_page_header                                       |
      | Yes              | Providing evidence of domestic violence or abuse concerns |
      | No               | Safety concerns                                           |
