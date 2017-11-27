require 'spec_helper'

RSpec.describe Steps::SafetyQuestions::OtherAbuseForm do
  it_behaves_like 'a yes-no question form', attribute_name: :other_abuse
end
