require 'spec_helper'

RSpec.describe Steps::Permission::AmendmentForm do
  it_behaves_like 'a permission yes-no question form',
                  attribute_name: :amendment
end
