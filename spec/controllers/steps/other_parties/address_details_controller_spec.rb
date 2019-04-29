require 'rails_helper'

RSpec.describe Steps::OtherParties::AddressDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::OtherParties::AddressDetailsForm, C100App::OtherPartiesDecisionTree
end
