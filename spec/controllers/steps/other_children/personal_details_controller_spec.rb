require 'rails_helper'

RSpec.describe Steps::OtherChildren::PersonalDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::OtherChildren::PersonalDetailsForm, C100App::OtherChildrenDecisionTree
end
