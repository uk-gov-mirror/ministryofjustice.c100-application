require 'spec_helper'

RSpec.describe Steps::SafetyQuestions::RiskOfAbductionForm do
  it_behaves_like 'a yes-no question form', attribute_name: :risk_of_abduction
end
