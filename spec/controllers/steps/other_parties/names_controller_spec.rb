require 'rails_helper'

RSpec.describe Steps::OtherParties::NamesController, type: :controller do
  it_behaves_like 'a names CRUD step controller',
                  Steps::OtherParties::NamesSplitForm,
                  C100App::OtherPartiesDecisionTree,
                  OtherParty
end
