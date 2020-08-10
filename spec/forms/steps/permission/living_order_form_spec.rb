require 'spec_helper'

RSpec.describe Steps::Permission::LivingOrderForm do
  it_behaves_like 'a permission yes-no question form',
                  attribute_name: :living_order,
                  reset_when_yes: [
                      :amendment,
                  ]
end
