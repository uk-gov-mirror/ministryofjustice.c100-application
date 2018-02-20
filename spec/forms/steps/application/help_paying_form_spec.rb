require 'spec_helper'

RSpec.describe Steps::Application::HelpPayingForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name:   :help_paying,
                  linked_attribute: :hwf_reference_number,
                  reset_when_no:    [:hwf_reference_number]
end
