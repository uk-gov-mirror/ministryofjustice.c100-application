require 'rails_helper'

RSpec.describe Steps::Screener::EmailConsentController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Screener::EmailConsentForm, C100App::ScreenerDecisionTree
end
