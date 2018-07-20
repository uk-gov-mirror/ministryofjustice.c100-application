class ScreenerAnswers < ApplicationRecord
  belongs_to :c100_application

  def court
    Court.new(local_court) if local_court
  end
end
