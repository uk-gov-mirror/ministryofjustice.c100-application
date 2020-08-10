require 'spec_helper'

RSpec.describe Steps::Permission::TimeOrderForm do
  it_behaves_like 'a permission yes-no question form',
                  attribute_name: :time_order
end
