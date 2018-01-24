require 'rails_helper'

RSpec.describe Steps::PostcodeScreen::ChildrenPostcodesController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::PostcodeScreen::ChildrenPostcodesForm, C100App::PostcodeScreenDecisionTree
end
