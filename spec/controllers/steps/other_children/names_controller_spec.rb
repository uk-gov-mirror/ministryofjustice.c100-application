require 'rails_helper'

RSpec.describe Steps::OtherChildren::NamesController, type: :controller do
  it_behaves_like 'an intermediate CRUD step controller',
                  Steps::OtherChildren::NamesForm,
                  C100App::OtherChildrenDecisionTree,
                  Child
end
