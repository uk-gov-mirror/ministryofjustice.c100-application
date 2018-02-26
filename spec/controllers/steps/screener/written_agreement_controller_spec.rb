require 'rails_helper'

RSpec.describe Steps::Screener::WrittenAgreementController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Screener::WrittenAgreementForm, C100App::ScreenerDecisionTree
end
