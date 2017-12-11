require 'rails_helper'

RSpec.describe Steps::OtherParties::NamesController, type: :controller do
  it_behaves_like 'an names CRUD step controller',
                  Steps::OtherParties::NamesForm,
                  C100App::OtherPartiesDecisionTree,
                  OtherParty
end
