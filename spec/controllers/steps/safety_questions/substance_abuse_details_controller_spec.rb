require 'rails_helper'

RSpec.describe Steps::SafetyQuestions::SubstanceAbuseDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::SafetyQuestions::SubstanceAbuseDetailsForm, C100App::SafetyQuestionsDecisionTree
end
