class ScreenerAnswers < ApplicationRecord
  belongs_to :c100_application

  def self.attributes_to_validate
    attribute_names - %w[created_at updated_at email_address]
  end.freeze

  validates_presence_of attributes_to_validate, on: :completion

  def court
    Court.new(local_court) if local_court
  end

  # Can be used to repeat the postcode lookup in CTF and save the
  # new court details to the database, when court/slug changes.
  #
  def refresh_local_court!
    courts = C100App::CourtPostcodeChecker.new.courts_for(children_postcodes)
    return unless courts.any?

    court = Court.new(courts.first)
    update_column(:local_court, court)
  end
end
