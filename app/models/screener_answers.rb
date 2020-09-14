class ScreenerAnswers < ApplicationRecord
  belongs_to :c100_application

  # Absolute minimum details needed to consider the screener completed
  def self.attributes_to_validate
    %w[children_postcodes]
  end.freeze

  validates_presence_of attributes_to_validate, on: :completion

  def court
    Court.build(local_court) if local_court
  end
end
