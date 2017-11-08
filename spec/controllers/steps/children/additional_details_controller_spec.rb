require 'rails_helper'

RSpec.describe Steps::Children::AdditionalDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Children::AdditionalDetailsForm, C100App::ChildrenDecisionTree
end
