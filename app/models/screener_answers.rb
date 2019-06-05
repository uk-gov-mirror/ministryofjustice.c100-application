class ScreenerAnswers < ApplicationRecord
  belongs_to :c100_application

  def self.attributes_to_validate
    attribute_names - %w[id c100_application_id created_at updated_at email_address]
  end.freeze

  validates_presence_of attributes_to_validate, on: :completion

  def court
    Court.new(local_court) if local_court
  end
end
