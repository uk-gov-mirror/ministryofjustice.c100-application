require 'rails_helper'

RSpec.describe Steps::Screener::UrgencyController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Screener::UrgencyForm, C100App::ScreenerDecisionTree
end
