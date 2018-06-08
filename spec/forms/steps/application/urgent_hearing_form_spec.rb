require 'spec_helper'

RSpec.describe Steps::Application::UrgentHearingForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name: :urgent_hearing
end
