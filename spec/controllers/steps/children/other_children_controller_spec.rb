require 'rails_helper'

RSpec.describe Steps::Children::OtherChildrenController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Children::OtherChildrenForm, C100App::ChildrenDecisionTree
end
