require 'spec_helper'

RSpec.describe Steps::Application::IntermediaryForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name:   :intermediary_help,
                  linked_attribute: :intermediary_help_details,
                  reset_when_no:   [:intermediary_help_details]
end
