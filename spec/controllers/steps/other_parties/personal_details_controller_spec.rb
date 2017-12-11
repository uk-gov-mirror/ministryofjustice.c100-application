require 'rails_helper'

RSpec.describe Steps::OtherParties::PersonalDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::OtherParties::PersonalDetailsForm, C100App::OtherPartiesDecisionTree
end
