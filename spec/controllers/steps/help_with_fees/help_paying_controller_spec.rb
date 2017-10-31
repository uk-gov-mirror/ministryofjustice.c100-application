require 'rails_helper'

RSpec.describe Steps::HelpWithFees::HelpPayingController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::HelpWithFees::HelpPayingForm, C100App::HelpWithFeesDecisionTree
end
