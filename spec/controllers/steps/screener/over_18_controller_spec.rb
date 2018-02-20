require 'rails_helper'

RSpec.describe Steps::Screener::Over18Controller, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Screener::Over18Form, C100App::ScreenerDecisionTree
end
