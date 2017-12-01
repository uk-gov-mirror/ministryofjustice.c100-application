require 'rails_helper'

RSpec.describe Steps::Children::NamesController, type: :controller do
  it_behaves_like 'an intermediate CRUD step controller',
                  Steps::Children::NamesForm,
                  C100App::ChildrenDecisionTree,
                  Child
end
