class ScreenerAnswers < ApplicationRecord
  belongs_to :c100_application

  def court
    Court.new.from_courtfinder_data!(local_court) if local_court
  end
end
