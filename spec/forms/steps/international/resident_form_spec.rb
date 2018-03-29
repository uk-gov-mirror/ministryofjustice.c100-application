require 'spec_helper'

RSpec.describe Steps::International::ResidentForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name:   :international_resident
end
