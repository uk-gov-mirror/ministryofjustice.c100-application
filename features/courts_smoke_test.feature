@smoke
Feature: Courts smoke test

  # Note: this is a very high level smoke test to ensure the slugs we use in the service
  # are correct, with no typos, and found in Court Tribunal Finder service.
  #
  # Dot not relay on this, but at least, if the slug for a court changes, or the court
  # gets disabled/removed, this smoke test will fail, giving us a heads up.

  Scenario: Court slugs are found in Court Tribunal Finder
    When Using the court slugs defined in the service
    Then Iterate through each court slug and call the API
