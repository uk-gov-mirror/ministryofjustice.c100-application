require 'rails_helper'

RSpec.describe Steps::Screener::LegalRepresentationController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Screener::LegalRepresentationForm, C100App::ScreenerDecisionTree
end
