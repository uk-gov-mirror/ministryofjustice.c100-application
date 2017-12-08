require 'rails_helper'

RSpec.describe Steps::OtherChildren::NamesController, type: :controller do
  it_behaves_like 'an names CRUD step controller',
                  Steps::OtherChildren::NamesForm,
                  C100App::OtherChildrenDecisionTree,
                  OtherChild
end
