require 'spec_helper'

RSpec.describe Steps::Miam::ChildProtectionCasesForm do
  it_behaves_like 'a yes-no question form', attribute_name: :child_protection_cases
end
