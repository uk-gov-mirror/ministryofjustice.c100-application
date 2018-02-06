require 'rails_helper'

RSpec.describe Steps::Screener::PostcodeController, type: :controller do
  it_behaves_like 'a starting point step controller'
  it_behaves_like 'an intermediate step controller', Steps::Screener::PostcodeForm, C100App::ScreenerDecisionTree

end
