require 'spec_helper'

RSpec.describe Steps::Application::LanguageForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name:   :language_help,
                  linked_attribute: :language_help_details,
                  reset_when_no:   [:language_help_details]
end
