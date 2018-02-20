require 'rails_helper'

RSpec.describe Steps::Screener::ParentController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Screener::ParentForm, C100App::ScreenerDecisionTree
end
