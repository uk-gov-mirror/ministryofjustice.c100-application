require 'spec_helper'

RSpec.describe Steps::Miam::ConsentOrderForm do
  it_behaves_like 'a yes-no question form', attribute_name: :consent_order
end
