require 'spec_helper'

RSpec.describe Steps::Application::SpecialAssistanceForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name:   :special_assistance,
                  linked_attribute: :special_assistance_details,
                  reset_when_no:   [:special_assistance_details]
end
