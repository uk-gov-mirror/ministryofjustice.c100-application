require 'rails_helper'

RSpec.describe Steps::OtherParties::ContactDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::OtherParties::ContactDetailsForm, C100App::OtherPartiesDecisionTree
end
