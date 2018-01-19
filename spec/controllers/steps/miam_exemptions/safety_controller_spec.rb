require 'rails_helper'

RSpec.describe Steps::MiamExemptions::SafetyController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::MiamExemptions::SafetyForm, C100App::MiamExemptionsDecisionTree
end
