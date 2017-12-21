require 'rails_helper'

RSpec.describe Steps::OtherParties::RelationshipController, type: :controller do
  it_behaves_like 'a relationship step controller', Steps::Shared::RelationshipForm, C100App::OtherPartiesDecisionTree
end
