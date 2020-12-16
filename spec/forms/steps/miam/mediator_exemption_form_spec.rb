require 'spec_helper'

RSpec.describe Steps::Miam::MediatorExemptionForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name: :miam_mediator_exemption,
                  reset_when_yes: [:miam_exemption_claim, :miam_exemption]
end
