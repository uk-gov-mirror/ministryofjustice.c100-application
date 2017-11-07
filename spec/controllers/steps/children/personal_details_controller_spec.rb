require 'rails_helper'

RSpec.describe Steps::Children::PersonalDetailsController, type: :controller do
  it_behaves_like 'an intermediate CRUD step controller',
                  Steps::Children::PersonalDetailsForm,
                  C100App::ChildrenDecisionTree,
                  Child
end
