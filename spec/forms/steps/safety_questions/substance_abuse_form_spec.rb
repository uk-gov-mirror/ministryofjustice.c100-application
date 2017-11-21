require 'spec_helper'

RSpec.describe Steps::SafetyQuestions::SubstanceAbuseForm do
  it_behaves_like 'a yes-no question form', attribute_name: :substance_abuse
end
