require 'spec_helper'

RSpec.describe Steps::Application::SpecialArrangementsForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name:   :special_arrangements,
                  linked_attribute: :special_arrangements_details,
                  reset_when_no:   [:special_arrangements_details]
end
