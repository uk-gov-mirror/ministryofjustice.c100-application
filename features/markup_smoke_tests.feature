Feature: High level form markup smoke tests
  Background:
    Given I have started an application

  Scenario Outline: Markup in a sample of forms should be correct
    When I visit "<step_path>"

    Then The form markup should match "<fixture_file>"
    Then The form markup with errors should match "<errors_fixture_file>"

    Examples:
      | step_path                         | fixture_file            | errors_fixture_file                 |
      | steps/miam/child_protection_cases | child_protection_cases  | child_protection_cases_with_errors  |
      | steps/miam/acknowledgement        | miam_acknowledgement    | miam_acknowledgement_with_errors    |
