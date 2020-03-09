class ApplicationFulfilmentValidator < ActiveModel::Validator
  include Rails.application.routes.url_helpers

  def validate(record)
    return unless must_validate?(record)

    validations.each do |validation|
      if (attribute, error, change_path = validation.call(record))
        record.errors.add(attribute, error, change_path: change_path)
      end
    end
  end

  private

  # As we are not yet releasing this to final users, we enable/disable these
  # validations by using a feature-flag based on whether the court data is fake
  # (a fixture) or not.
  #
  # Currently, ONLY if the court data is fake (meaning we've used the `bypass`
  # functionality) these validations will run. This allow us to easily "see"
  # the validations and check the design until it is ready for release.
  #
  def must_validate?(record)
    record.screener_answers.local_court.key?('_fixture')
  end

  # Individual validations to be added here
  # Final list to be defined
  #
  def validations
    [
      ->(record) { [:applicants, :blank, edit_steps_applicant_names_path(id: '')] unless record.applicants.any? },
    ]
  end
end
