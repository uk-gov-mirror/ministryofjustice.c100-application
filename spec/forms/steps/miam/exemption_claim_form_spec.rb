require 'spec_helper'

RSpec.describe Steps::Miam::ExemptionClaimForm do
  it_behaves_like 'a yes-no question form', attribute_name: :miam_exemption_claim
end
