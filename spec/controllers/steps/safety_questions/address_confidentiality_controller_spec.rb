require 'rails_helper'

RSpec.describe Steps::SafetyQuestions::AddressConfidentialityController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::SafetyQuestions::AddressConfidentialityForm, C100App::SafetyQuestionsDecisionTree
end
