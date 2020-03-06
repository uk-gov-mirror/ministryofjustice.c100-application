class ApplicationFulfilmentValidator < ActiveModel::Validator
  include Rails.application.routes.url_helpers

  def validate(record)
    validations.each do |validation|
      if (attribute, error, change_path = validation.call(record))
        record.errors.add(attribute, error, change_path: change_path)
      end
    end
  end

  private

  # Individual validations to be added here
  # Final list to be defined
  #
  def validations
    [
      ->(record) { [:applicants, :blank, edit_steps_applicant_names_path(id: '')] unless record.applicants.any? },
    ]
  end
end
